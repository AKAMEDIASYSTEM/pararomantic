local MAG_CAL_REPORT = {}
MAG_CAL_REPORT.id = 192
MAG_CAL_REPORT.fields = {
             { "fitness", "<f" },
             { "ofs_x", "<f" },
             { "ofs_y", "<f" },
             { "ofs_z", "<f" },
             { "diag_x", "<f" },
             { "diag_y", "<f" },
             { "diag_z", "<f" },
             { "offdiag_x", "<f" },
             { "offdiag_y", "<f" },
             { "offdiag_z", "<f" },
             { "compass_id", "<B" },
             { "cal_mask", "<B" },
             { "cal_status", "<B" },
             { "autosaved", "<B" },
             }
return MAG_CAL_REPORT
