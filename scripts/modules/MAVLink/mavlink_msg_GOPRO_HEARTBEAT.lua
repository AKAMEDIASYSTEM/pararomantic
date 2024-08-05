local GOPRO_HEARTBEAT = {}
GOPRO_HEARTBEAT.id = 215
GOPRO_HEARTBEAT.fields = {
             { "status", "<B" },
             { "capture_mode", "<B" },
             { "flags", "<B" },
             }
return GOPRO_HEARTBEAT
