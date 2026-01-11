return {
    settings = {
        Lua = {
            telemetry = { enable = false },
            diagnostics = {
                globals = {
                    'vim',                   -- Vim
                    'redis', 'ARGV', 'KEYS', -- Redis
                }
            }
        }
    }
}
