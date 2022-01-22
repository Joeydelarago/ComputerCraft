args = {...}

shell.run("monitor", "top", args[1])

-- m = peripheral.wrap("top", "monitor")
-- term.redirect(peripheral.wrap("top"))