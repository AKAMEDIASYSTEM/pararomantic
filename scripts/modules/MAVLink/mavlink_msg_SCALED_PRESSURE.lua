local SCALED_PRESSURE = {}
SCALED_PRESSURE.id = 29
SCALED_PRESSURE.fields = {
             { "time_boot_ms", "<I4" },
             { "press_abs", "<f" },
             { "press_diff", "<f" },
             { "temperature", "<i2" },
             }
return SCALED_PRESSURE
