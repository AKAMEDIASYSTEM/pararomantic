local OPTICAL_FLOW = {}
OPTICAL_FLOW.id = 100
OPTICAL_FLOW.fields = {
             { "time_usec", "<I8" },
             { "flow_comp_m_x", "<f" },
             { "flow_comp_m_y", "<f" },
             { "ground_distance", "<f" },
             { "flow_x", "<i2" },
             { "flow_y", "<i2" },
             { "sensor_id", "<B" },
             { "quality", "<B" },
             }
return OPTICAL_FLOW
