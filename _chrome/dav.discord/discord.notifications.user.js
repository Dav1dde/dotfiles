/**
 * Simple script that attaches itself to the discord DOM
 * and checks for notifciations/pings in guilds/servers.
 * If there is an active notification the <title> will be
 * prefixed with a special indicator, defaults to `* `.
 *
 * Install via "unpacked extension" in the chrome
 * extension menu.
 */


// Indicator added to the tile when there are notifications
let INDICATOR = '* ';


function has_notifications() {
    return !!document.querySelector('.guild > .badge');
}

function add_indicator() {
    var title = document.querySelector('title');
    if (!title.innerHTML.startsWith(INDICATOR)) {
        title.innerHTML = INDICATOR + title.innerHTML;
    }
}

function strip_indicator() {
    var title = document.querySelector('title');
    if (title.innerHTML.startsWith(INDICATOR)) {
        title.innerHTML = title.innerHTML.substring(INDICATOR.length);
    }
}

function annotate() {
    if (has_notifications()) {
        add_indicator();
    } else {
        strip_indicator();
    }
}

function main() {
    let nobs = new MutationObserver(function (mutations) { annotate(); });

    // TODO: get rid of that setInterval and recognize
    // when discord has loaded
    function connect_observer() {
        let guilds = document.querySelector('.guilds');
        nobs.disconnect();
        if (!!guilds) {
            nobs.observe(guilds, {childList: true, subtree: true});
            annotate();
        }
    }

    setInterval(connect_observer, 60000);
    setTimeout(connect_observer, 10000);
}

main();
