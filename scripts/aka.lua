
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

-- Function to check if the quadcopter is armed and above 3 meters
function is_above_3m_and_armed()
    return arming:is_armed() and vehicle:get_relative_alt() >= 3
end

function send_status_text()
    local textArray = {
    "CAN YOU MEET ME IN THE LOOP",
    "CAN WE COMMUNICATE",
    " - ",
    "OUR MOMENT UP HERE",
    "BARELY HANGING ON",
    "ALWAYS ALREADY FALLING",
    "GASPING ECSTATIC",
    " ",
    "HEEDLESS ALOFT",
    " - ",
    "JUST HOW I LIKE IT",
    " ",
    " - ",
    "BREATHE",
    " ",
    " - ",
    "BREATHE",
    " ",
    " ",
    "O GOD I HAVE GOT",
    " ",
    "O GOD I HAVE GOT",
    " ",
    "A FEELING SO LOVELY",
    "A FEELING SO LOVELY",
    "INTIMATE TELEMETRY",
    " ",
    "THIS ENCOUNTER",
    " ",
    "WARM IN YOUR HIGH BEAMS",
    " ",
    "YAWPING MY EARNEST BIRDSONG",
    " ",
    "SURE AS A ROCKSLIDE",
    "SURE AS A ROCKSLIDE",
    "SURE AS A ROCKSLIDE",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " "
    }

    -- Ensure currentIndex is within bounds
    if currentIndex > #textArray or currentIndex < 1 then
        gcs:send_text(2, "currentIndex out of bounds: " .. tostring(currentIndex))
        currentIndex = 1  -- Reset to 1 if out of bounds
    end

    if is_above_3m_and_armed() then
        local the_text = textArray[currentIndex]
        local truncated_text = the_text:sub(1, 50)
        -- gcs:send_text(2, truncated_text)
        local result_mission_planner = mavlink:send_chan(0, mavlink_msgs.encode("STATUSTEXT", {severity = tseverity, text =truncated_text}))
        local result_radio_telem = mavlink:send_chan(1, mavlink_msgs.encode("STATUSTEXT", {severity = tseverity, text =truncated_text}))
        -- local result_mission_planner = mavlink:send_chan(0, mavlink_msgs.encode("STATUSTEXT", {severity = tseverity, text=truncated_text}))
        local result_osd = mavlink:send_chan(2, mavlink_msgs.encode("STATUSTEXT", {severity= tseverity, text=truncated_text}))

        -- Increment currentIndex for the next run
        currentIndex = currentIndex + 1
        if currentIndex > #textArray then
            currentIndex = 1  -- Loop back to the first message
        end
    else
        local result_mission_planner = mavlink:send_chan(0, mavlink_msgs.encode("STATUSTEXT", {severity = tseverity, text ="AWAITING PERFECT TIME"}))
        local result_radio_telem = mavlink:send_chan(1, mavlink_msgs.encode("STATUSTEXT", {severity = tseverity, text ="AWAITING PERFECT TIME"}))
        -- local result_mission_planner = mavlink:send_chan(0, mavlink_msgs.encode("STATUSTEXT", {severity = tseverity, text="AWAITING PERFECT TIME"}))
        local result_osd = mavlink:send_chan(2, mavlink_msgs.encode("STATUSTEXT", {severity= tseverity, text="AWAITING PERFECT TIME"}))
    
    return send_status_text, 7000
end

return send_status_text()