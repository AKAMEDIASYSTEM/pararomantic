local POWER_STATUS = {}
POWER_STATUS.id = 125
POWER_STATUS.fields = {
             { "Vcc", "<I2" },
             { "Vservo", "<I2" },
             { "flags", "<I2" },
             }
return POWER_STATUS
