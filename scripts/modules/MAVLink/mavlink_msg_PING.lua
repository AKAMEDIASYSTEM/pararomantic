local PING = {}
PING.id = 4
PING.fields = {
             { "time_usec", "<I8" },
             { "seq", "<I4" },
             { "target_system", "<B" },
             { "target_component", "<B" },
             }
return PING
