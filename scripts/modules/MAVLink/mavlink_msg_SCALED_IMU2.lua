local SCALED_IMU2 = {}
SCALED_IMU2.id = 116
SCALED_IMU2.fields = {
             { "time_boot_ms", "<I4" },
             { "xacc", "<i2" },
             { "yacc", "<i2" },
             { "zacc", "<i2" },
             { "xgyro", "<i2" },
             { "ygyro", "<i2" },
             { "zgyro", "<i2" },
             { "xmag", "<i2" },
             { "ymag", "<i2" },
             { "zmag", "<i2" },
             }
return SCALED_IMU2
