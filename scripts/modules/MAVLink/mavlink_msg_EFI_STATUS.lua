local EFI_STATUS = {}
EFI_STATUS.id = 225
EFI_STATUS.fields = {
             { "ecu_index", "<f" },
             { "rpm", "<f" },
             { "fuel_consumed", "<f" },
             { "fuel_flow", "<f" },
             { "engine_load", "<f" },
             { "throttle_position", "<f" },
             { "spark_dwell_time", "<f" },
             { "barometric_pressure", "<f" },
             { "intake_manifold_pressure", "<f" },
             { "intake_manifold_temperature", "<f" },
             { "cylinder_head_temperature", "<f" },
             { "ignition_timing", "<f" },
             { "injection_time", "<f" },
             { "exhaust_gas_temperature", "<f" },
             { "throttle_out", "<f" },
             { "pt_compensation", "<f" },
             { "health", "<B" },
             }
return EFI_STATUS
