
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

function send_status_text()
    -- Example usage
    local tseverity = 2  -- "Critical" level
    local the_text = "O GOD I HAVE GOT A FEELING SO LOVELY"
    -- Ensure the text is not longer than 50 characters
    local truncated_text = the_text:sub(1, 50)
    -- Check if mavlink object is initialized
    if mavlink == nil then
        gcs:send_text(2, "MAVLink object is nil")
        return
    end
    
    -- Send the message
    -- mavlink:send(chan, mavlink_msgs.encode("MSG_NAME", {param1 = value1, param2 = value2, ...}})
    -- local result = mavlink:send_chan(0, mavlink_msgs.encode(id, {severity = severity, text = truncated_text}))
    local result_mission_planner = mavlink:send_chan(0, mavlink_msgs.encode("STATUSTEXT", {severity = tseverity, text = "USB TELEMETRY"}))
    local result_radio_telem = mavlink:send_chan(1, mavlink_msgs.encode("STATUSTEXT", {severity = tseverity, text = "RADIO TELEMETRY"}))
    local result_osd = mavlink:send_chan(2, mavlink_msgs.encode("STATUSTEXT", {severity = tseverity, text = "OSD TELEMETRY"}))
    
    -- Check if the send was successful
    if result_osd then
        gcs:send_text(6, "STATUSTEXT message sent: " .. the_text)
    else
        gcs:send_text(2, "Failed to send STATUSTEXT message")
    end
    return send_status_text, 3000
end

return send_status_text()