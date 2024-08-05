local GPS2_RAW = {}
GPS2_RAW.id = 124
GPS2_RAW.fields = {
             { "time_usec", "<I8" },
             { "lat", "<i4" },
             { "lon", "<i4" },
             { "alt", "<i4" },
             { "dgps_age", "<I4" },
             { "eph", "<I2" },
             { "epv", "<I2" },
             { "vel", "<I2" },
             { "cog", "<I2" },
             { "fix_type", "<B" },
             { "satellites_visible", "<B" },
             { "dgps_numch", "<B" },
             }
return GPS2_RAW
