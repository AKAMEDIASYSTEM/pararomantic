local CAMERA_FEEDBACK = {}
CAMERA_FEEDBACK.id = 180
CAMERA_FEEDBACK.fields = {
             { "time_usec", "<I8" },
             { "lat", "<i4" },
             { "lng", "<i4" },
             { "alt_msl", "<f" },
             { "alt_rel", "<f" },
             { "roll", "<f" },
             { "pitch", "<f" },
             { "yaw", "<f" },
             { "foc_len", "<f" },
             { "img_idx", "<I2" },
             { "target_system", "<B" },
             { "cam_idx", "<B" },
             { "flags", "<B" },
             }
return CAMERA_FEEDBACK
