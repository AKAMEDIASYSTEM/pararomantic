local DISTANCE_SENSOR = {}
DISTANCE_SENSOR.id = 132
DISTANCE_SENSOR.fields = {
             { "time_boot_ms", "<I4" },
             { "min_distance", "<I2" },
             { "max_distance", "<I2" },
             { "current_distance", "<I2" },
             { "type", "<B" },
             { "id", "<B" },
             { "orientation", "<B" },
             { "covariance", "<B" },
             }
return DISTANCE_SENSOR
