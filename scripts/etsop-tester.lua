
local mavlink_msgs = require("MAVLink/mavlink_msgs")

mavlink:init(1, 10)

-- Ensure MAVLink message IDs are defined
-- MAVLINK_MSG_ID_STATUSTEXT = 253
-- severity reference:
    -- 0: Emergency - System is unusable. This is a "panic" condition.
    -- 1: Alert - Immediate action is required.
    -- 2: Critical - Critical conditions, system failure, etc.
    -- 3: Error - Error conditions.
    -- 4: Warning - Warning conditions, operation may continue.
    -- 5: Notice - Normal but significant condition.
    -- 6: Info - Informational messages.
    -- 7: Debug - Debug-level messages, typically of interest only when diagnosing problems.
-- got this all working by generating all the mavlink bindigs mentioned here: https://github.com/ArduPilot/ardupilot/tree/master/libraries/AP_Scripting/modules/MAVLink
-- had to git clone the ,ain ardupilot repo AND specificall yclone the mavlink submodule like so:
-- git submodule update --init --recursive modules/mavlink 
-- after first running git clone git@github.com:ArduPilot/ardupilot.git
-- i didn't need to clone the full ardupilot/mavlink or ardupilot/pymavlink repos but initially thought I did b/c I did not realize submodules were empty
-- the "chan" in mavlink_msgs:send_chan refers basically to which UART/Serial the ,avlink payloaad goes ot over.
-- in mavlink_msgs:send_chan, chan0 is USB debug port, chan1 is radio telemetry (UART7/telem1) and chan2 is OSD (UART5/telem2)
-- note for other mavlink send functions you gotta have the corresponding mavlink_msg_FOOMSG.lua file (generated per line 17) in scripts/modules/MAVLink/
local RC7 = rc:get_channel(7)
local tseverity = 2  -- "Critical" level
currentIndex = 1
-- Wait for arming, activate motor E-stop, and reset after 2500ms

local wait_before_stop = 30000  -- Time to wait before activating emergency stop (ms)
local stop_duration = 2700     -- Duration of emergency stop (ms)

local is_armed = false  -- Track armed state
local e_stop_activated = false  -- Track if emergency stop is active
local start_time = 0  -- Timer start for state transitions
local CLEAR_OVERRIDE = 0
local ENGAGE_ESTOP = 2000


function update()
    -- Check if the vehicle is armed
    if not is_armed and arming:is_armed() then
        -- Quad just got armed
        is_armed = true
        gcs:send_text(6, "Quadcopter armed. Waiting to activate E-stop.")
        start_time = millis()  -- Record the time at arming
    elseif is_armed and not arming:is_armed() then
        -- Quad got disarmed
        is_armed = false
        e_stop_activated = false
        gcs:send_text(6, "Quadcopter disarmed. Resetting.")
    end

    -- Check if 3 seconds have passed since arming
    if is_armed and not e_stop_activated and millis() - start_time >= wait_before_stop then
        -- Activate emergency stop
        gcs:send_text(6, "Activating emergency stop!")
        -- Simulate E-stop by disarming (or use actual motor stop if available)
        RC7:set_override(ENGAGE_ESTOP)
        e_stop_activated = true
        start_time = millis()  -- Reset the timer for stop duration
    end

    -- Check if E-stop duration has passed and deactivate
    if e_stop_activated and millis() - start_time >= stop_duration then
        -- Deactivate emergency stop
        gcs:send_text(6, "Deactivating emergency stop. Re-arming.")
        RC7:set_override(CLEAR_OVERRIDE)
        e_stop_activated = false
    end

    -- Run this function at 10Hz
    return update, 100
end

return update()
