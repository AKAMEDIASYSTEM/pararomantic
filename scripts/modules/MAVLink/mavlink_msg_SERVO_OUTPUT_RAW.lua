local SERVO_OUTPUT_RAW = {}
SERVO_OUTPUT_RAW.id = 36
SERVO_OUTPUT_RAW.fields = {
             { "time_usec", "<I4" },
             { "servo1_raw", "<I2" },
             { "servo2_raw", "<I2" },
             { "servo3_raw", "<I2" },
             { "servo4_raw", "<I2" },
             { "servo5_raw", "<I2" },
             { "servo6_raw", "<I2" },
             { "servo7_raw", "<I2" },
             { "servo8_raw", "<I2" },
             { "port", "<B" },
             }
return SERVO_OUTPUT_RAW
