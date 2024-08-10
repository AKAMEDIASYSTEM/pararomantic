
local mavlink_msgs = require("MAVLink/mavlink_msgs")
-- Initialize the mavlink object
mavlink:init(1, 10)  -- Adjust the parameters as needed for your use case

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
-- the "chan" in mavlink_msgs:send_chan refers basically to which UART/Serial the ,avlink payloaad goes ot over. That's why I'm sending twice
-- once to chan 0 (usb serial debug link to mission planner) and once to chan 2 (presumably UART5/Telemetry2, which is what minimOSD is on)
-- tomorrow validate that chan 1 is the 915MHz telemetry link

-- note for other mavlink send functions you gotta have the corresponding mavlink_msg_FOOMSG.lua file (generated per line 17) in scripts/modules/MAVLink/

local tseverity = 3  -- "Error" level
local currentIndex = 1

function send_status_text()
    local textArray = {
    "CAN YOU MEET ME IN THE LOOP",
    "TWO HAWKS SKY-WHEELING",
    "INTIMATE TELEMETRY",
    "FEELINGS - I WATCH THIS ONE GO BY",
    "OUR MOMENT UP HERE",
    "BARELY HANGING ON",
    "JUST HOW I LIKE IT"
    }
    -- gcs:send_text(2, "Script started/restarted. Current Index: " .. tostring(currentIndex))

    -- Ensure currentIndex is within bounds
    -- if currentIndex > #textArray or currentIndex < 1 then
    --     gcs:send_text(2, "currentIndex out of bounds: " .. tostring(currentIndex))
    --     currentIndex = 1  -- Reset to 1 if out of bounds
    -- end

    local the_text = textArray[currentIndex]

-- -- Type-checking the_text to ensure it is not a number
--     if type(the_text) ~= "string" then
--         gcs:send_text(2, "Error: the_text is of type " .. type(the_text) .. " at index: " .. tostring(currentIndex))
--         return
--     end


    local truncated_text = the_text:sub(1, 50)
    gcs:send_text(2, currentIndex .. "_truncated is_" .. truncated_text)

-- -- Type-checking truncated_text to ensure it is not a number
--     if type(truncated_text) ~= "string" then
--         gcs:send_text(2, "Error: truncated_text is of type " .. type(truncated_text) .. " at index: " .. tostring(currentIndex))
--         return
--     end

--     if the_text == nil then
--         gcs:send_text(2, "the_text is nil at index: " .. tostring(currentIndex))
--         return
--     end

--     if mavlink == nil then
--             gcs:send_text(2, "MAVLink object is nil")
--             return
--         end

--     -- Log truncated_text and tseverity
--     gcs:send_text(2, tostring(truncated_text))

--     -- -- Attempt to encode the message
--     local msg_id, encoded_message = mavlink_msgs.encode("STATUSTEXT", {severity = 2, text = truncated_text})


    -- Check if encoding was successful
    -- if encoded_message == nil then
    --     gcs:send_text(2, "Error: mavlink_msgs.encode returned nil")
    --     return
    -- end

    -- print("msg_id is_" .. msg_id)
    -- print("encoded is_" .. tostring(encoded_message))

    -- local result_mission_planner = mavlink:send_chan(0, mavlink_msgs.encode("STATUSTEXT", {severity = tseverity, text = "USB TELEMETRY"}))
    -- local result_radio_telem = mavlink:send_chan(1, mavlink_msgs.encode("STATUSTEXT", {severity = tseverity, text = "RADIO TELEMETRY"}))
    local result_osd = mavlink:send_chan(2, mavlink_msgs.encode("STATUSTEXT", {severity= tseverity, text=truncated_text}))
    -- local result_osd = mavlink:send_chan(2, msg_id, encoded_message)
    -- Increment currentIndex for the next run
    -- currentIndex = currentIndex + 1
    -- if currentIndex > #textArray then
    --     currentIndex = 1  -- Loop back to the first message
    -- end
    return send_status_text, 2000
end

return send_status_text()

-- function send_status_text_orig()
--     local tseverity = 2  -- "Critical" level
--     local the_text = textArray[currentIndex]
--     gcs:send_text(2, the_text)
--     local truncated_text = the_text:sub(1, 50)

--     gcs:send_text(2, "Current Index: " .. tostring(currentIndex))
--     -- gcs:send_text(2, "textArray size: " .. tostring(#textArray))

--     currentIndex = currentIndex + 1
--     if currentIndex > #textArray then
--         currentIndex = 1  -- Loop back to the first message (tables are weirdly 1-indexed gross)
--     end

--     -- Check if mavlink object is initialized
--     if mavlink == nil then
--         gcs:send_text(2, "MAVLink object is nil")
--         return
--     end
--     -- Send the message
--     -- mavlink:send(chan, mavlink_msgs.encode("MSG_NAME", {param1 = value1, param2 = value2, ...}})
--     -- local result = mavlink:send_chan(0, mavlink_msgs.encode(id, {severity = severity, text = truncated_text}))
    -- local result_mission_planner = mavlink:send_chan(0, mavlink_msgs.encode("STATUSTEXT", {severity = tseverity, text = "USB TELEMETRY"}))
    -- local result_radio_telem = mavlink:send_chan(1, mavlink_msgs.encode("STATUSTEXT", {severity = tseverity, text = "RADIO TELEMETRY"}))
    -- local result_osd = mavlink:send_chan(2, mavlink_msgs.encode("STATUSTEXT", {severity = tseverity, text = truncated_text}))
    
--     -- Check if the send was successful
--     -- if result_osd then
--     --     gcs:send_text(6, "STATUSTEXT message sent: " .. the_text)
--     -- else
--     --     gcs:send_text(2, "Failed to send STATUSTEXT message")
--     -- end
--     return send_status_text, 5000
-- end

-- return send_status_text()