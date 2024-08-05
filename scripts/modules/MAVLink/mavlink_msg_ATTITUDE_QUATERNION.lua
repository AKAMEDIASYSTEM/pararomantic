local ATTITUDE_QUATERNION = {}
ATTITUDE_QUATERNION.id = 31
ATTITUDE_QUATERNION.fields = {
             { "time_boot_ms", "<I4" },
             { "q1", "<f" },
             { "q2", "<f" },
             { "q3", "<f" },
             { "q4", "<f" },
             { "rollspeed", "<f" },
             { "pitchspeed", "<f" },
             { "yawspeed", "<f" },
             }
return ATTITUDE_QUATERNION
