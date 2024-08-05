local EKF_STATUS_REPORT = {}
EKF_STATUS_REPORT.id = 193
EKF_STATUS_REPORT.fields = {
             { "velocity_variance", "<f" },
             { "pos_horiz_variance", "<f" },
             { "pos_vert_variance", "<f" },
             { "compass_variance", "<f" },
             { "terrain_alt_variance", "<f" },
             { "flags", "<I2" },
             }
return EKF_STATUS_REPORT
