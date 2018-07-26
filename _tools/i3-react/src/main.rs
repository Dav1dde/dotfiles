extern crate i3ipc;
extern crate regex;
extern crate x11;
use i3ipc::event::Event;
use i3ipc::I3Connection;
use i3ipc::I3EventListener;
use i3ipc::Subscription;
use regex::Regex;
use std::cell::RefCell;
use x11::xlib;

pub trait ActionMatcher {
    fn matches(&self, node: &i3ipc::reply::Node) -> bool;
}

pub trait Action {
    fn execute(&self, connection: &mut I3Connection, node: &i3ipc::reply::Node);
}

struct X11Display {
    display: *mut xlib::Display
}

impl Drop for X11Display {
    fn drop(&mut self) {
        if !self.display.is_null() {
            unsafe {
                xlib::XCloseDisplay(self.display);
            }
            self.display = std::ptr::null_mut();
        }
    }
}

impl X11Display {
    pub fn new() -> Result<X11Display, ()> {
        unsafe {
            let display = xlib::XOpenDisplay(0 as *const i8);
            if display.is_null() {
                return Err(());
            }
            Ok(X11Display { display: display })
        }
    }

    pub fn set_urgency(&self, window_id: u64) -> Result<(), i32> {
        unsafe {
            let mut hints = xlib::XGetWMHints(self.display, window_id);
            if hints.is_null() {
                hints = xlib::XAllocWMHints();
                if hints.is_null() {
                    return Err(1);
                }
            }
            (*hints).flags = (*hints).flags | xlib::XUrgencyHint;
            let result = xlib::XSetWMHints(self.display, window_id, hints);
            xlib::XFree(hints as *mut std::os::raw::c_void);
            if result == 0 {
                return Err(2);
            }
            xlib::XFlush(self.display);
            Ok(())
        }
    }
}

struct UrgencyAction {
    display: X11Display,
}

impl Action for UrgencyAction {
    fn execute(&self, _connection: &mut I3Connection, node: &i3ipc::reply::Node) {
        if node.urgent || node.focused {
            return;
        }

        if let Some(window_id) = node.window {
            if let Err(code) = self.display.set_urgency(window_id as u64) {
                println!(
                    "unable to set urgency for window {} / {:?}, code {}",
                    window_id, node.name, code
                );
            }
        }
    }
}

impl UrgencyAction {
    pub fn new() -> Result<UrgencyAction, ()> {
        let display = X11Display::new()?;
        Ok(UrgencyAction { display: display })
    }
}

struct I3CommandAction {
    command: String,
}

impl Action for I3CommandAction {
    fn execute(&self, connection: &mut I3Connection, _node: &i3ipc::reply::Node) {
        connection
            .run_command(self.command.as_str())
            .expect("unable to send command");
    }
}

impl I3CommandAction {
    pub fn new(command: String) -> I3CommandAction {
        I3CommandAction { command: command }
    }
}

struct RegexMatcher {
    regex: Regex,
}

impl ActionMatcher for RegexMatcher {
    fn matches(&self, node: &i3ipc::reply::Node) -> bool {
        return match node.name {
            Some(ref name) => self.regex.is_match(name.as_str()),
            _ => false,
        };
    }
}

impl RegexMatcher {
    pub fn new(regex: Regex) -> RegexMatcher {
        RegexMatcher { regex }
    }
}

#[derive(Debug)]
pub enum CreateError {
    ConnectError(i3ipc::EstablishError),
    MessageError(i3ipc::MessageError),
}

pub struct I3React {
    connection: RefCell<I3Connection>,
    listener: RefCell<I3EventListener>,
    actions: Vec<(Box<ActionMatcher>, Box<Action>)>,
}

impl I3React {
    pub fn new() -> Result<I3React, CreateError> {
        let mut listener = I3EventListener::connect().map_err(|e| CreateError::ConnectError(e))?;
        listener
            .subscribe(&[Subscription::Window])
            .map_err(|e| CreateError::MessageError(e))?;

        let connection = I3Connection::connect().map_err(|e| CreateError::ConnectError(e))?;

        Ok(I3React {
            connection: RefCell::new(connection),
            listener: RefCell::new(listener),
            actions: Vec::new(),
        })
    }

    pub fn register(&mut self, matcher: Box<ActionMatcher>, action: Box<Action>) {
        self.actions.push((matcher, action));
    }

    pub fn run(&mut self) {
        let mut listener = self.listener.borrow_mut();
        for event in listener.listen() {
            if let Ok(Event::WindowEvent(e)) = event {
                for (matcher, action) in self.actions.iter() {
                    if matcher.as_ref().matches(&e.container) {
                        let mut connection = self.connection.borrow_mut();
                        action.execute(&mut connection, &e.container);
                    }
                }
            }
        }
    }
}

fn main() {
    let mut i3react = I3React::new().unwrap();

    i3react.register(
        Box::new(RegexMatcher::new(Regex::new(r"^\* .*$").unwrap())),
        Box::new(UrgencyAction::new().unwrap()),
    );

    i3react.register(
        Box::new(RegexMatcher::new(
            Regex::new(r"^\(\d+\).*The Lounge$").unwrap(),
        )),
        Box::new(UrgencyAction::new().unwrap()),
    );

    i3react.run();
}
