local BATTERY_STATUS = {}
BATTERY_STATUS.id = 147
BATTERY_STATUS.fields = {
             { "current_consumed", "<i4" },
             { "energy_consumed", "<i4" },
             { "temperature", "<i2" },
             { "voltages", "<I2", 10 },
             { "current_battery", "<i2" },
             { "id", "<B" },
             { "battery_function", "<B" },
             { "type", "<B" },
             { "battery_remaining", "<b" },
             }
return BATTERY_STATUS
