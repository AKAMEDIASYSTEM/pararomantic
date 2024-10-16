
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

local tseverity = 2  -- "Critical" level
currentIndex = 1
-- Define constants
local H = 10          -- Target altitude in meters
local T = 750        -- Disarm duration in milliseconds
local WAIT_TIME = 10000 -- Wait time after reaching altitude in milliseconds

-- State machine states
local STATE_IDLE = 0
local STATE_ASCEND = 1
local STATE_WAIT = 2
local STATE_DISARM = 3
local STATE_HOVER = 4

-- Initial state
local state = STATE_IDLE

-- Timers
local start_time = 0
local disarm_time = 0

-- Function to set mode
local function set_mode(mode)
    local mode_mapping = {
        ["AUTO"] = 10,
        ["LOITER"] = 5,
        ["LAND"] = 9,
    }
    return vehicle:set_mode(mode_mapping[mode])
end

-- Debug print function
local function debug_print(message)
    gcs:send_text(6, message)  -- Send message to GCS as a status text
end

-- Main update function
function update()
    -- Output current mode and altitude
    debug_print("Mode: " .. tostring(vehicle:get_mode()) .. ", Altitude: " .. tostring(ahrs:get_altitude()))

    -- Check if the vehicle is in AUTO mode
    if not arming:is_armed() or vehicle:get_mode() ~= 10 then
        state = STATE_IDLE
        debug_print("State: IDLE")
        return update, 1000
    end

    -- State machine
    if state == STATE_IDLE then
        -- Start ascending to the target altitude
        debug_print("State: ASCEND")
        state = STATE_ASCEND

    elseif state == STATE_ASCEND then
        if ahrs:get_altitude() < H then
            -- Command to ascend slowly
            local target_alt = math.min(ahrs:get_altitude() + 0.1, H)
            vehicle:set_target_altitude(target_alt)
            debug_print("Ascending, Target Altitude: " .. tostring(target_alt))
        else
            -- Reached target altitude, transition to wait state
            debug_print("Reached Target Altitude")
            start_time = millis()
            state = STATE_WAIT
        end

    elseif state == STATE_WAIT then
        if millis() - start_time >= WAIT_TIME then
            -- Wait time elapsed, transition to disarm state
            debug_print("State: DISARM, Waiting Time: " .. tostring(WAIT_TIME) .. " ms")
            vehicle:set_mode(9) -- LAND mode as a safety precaution
            disarm_time = millis()
            state = STATE_DISARM
        end

    elseif state == STATE_DISARM then
        if millis() - disarm_time >= T then
            -- Disarm duration elapsed, re-arm and switch to LOITER mode
            debug_print("State: HOVER, Disarm Time: " .. tostring(T) .. " ms")
            vehicle:set_mode(5) -- LOITER mode
            arming:arm()
            state = STATE_HOVER
        end

    elseif state == STATE_HOVER then
        -- Hover indefinitely in LOITER mode
        debug_print("State: HOVER, Maintaining Altitude: " .. tostring(H))
    end

    return update, 100 -- Update every 100 milliseconds
end

-- Start the script
return update()


-- function send_status_text()
--     local textArray = {
--     "CAN YOU MEET ME IN THE LOOP",
--     "FEELINGS - I WATCH THIS ONE GO BY",
--     "OUR MOMENT UP HERE",
--     "BARELY HANGING ON",
--     "JUST HOW I LIKE IT"
--     }

--     -- Ensure currentIndex is within bounds
--     if currentIndex > #textArray or currentIndex < 1 then
--         gcs:send_text(2, "currentIndex out of bounds: " .. tostring(currentIndex))
--         currentIndex = 1  -- Reset to 1 if out of bounds
--     end

--     local the_text = textArray[currentIndex]

--     local truncated_text = the_text:sub(1, 50)
--     -- gcs:send_text(2, truncated_text)
--     -- local result_mission_planner = mavlink:send_chan(0, mavlink_msgs.encode("STATUSTEXT", {severity = tseverity, text = "USB TELEMETRY"}))
--     -- local result_radio_telem = mavlink:send_chan(1, mavlink_msgs.encode("STATUSTEXT", {severity = tseverity, text = "RADIO TELEMETRY"}))
--     local result_mission_planner = mavlink:send_chan(0, mavlink_msgs.encode("STATUSTEXT", {severity = tseverity, text=truncated_text}))
--     local result_osd = mavlink:send_chan(2, mavlink_msgs.encode("STATUSTEXT", {severity= tseverity, text=truncated_text}))

--     -- Increment currentIndex for the next run
--     currentIndex = currentIndex + 1
--     if currentIndex > #textArray then
--         currentIndex = 1  -- Loop back to the first message
--     end
--     return send_status_text, 5000
-- end