local RC7 = rc:get_channel(7)
local CLEAR_OVERRIDE = 0
local ENGAGE_ESTOP = 2000

local START_SWOON = 15 -- swoon at 15m
local SAVE_YOURSELF = 10 -- for now, recover from swoon at 10m
local is_armed = false  -- Track armed state
local e_stop_activated = false  -- Track if emergency stop is active
local initial_heading = 0  -- Store the initial heading at the time of arming
local heading_tolerance = 10  -- Heading change tolerance in degrees

local tseverity = 2  -- "Critical" level
currentIndex = 1

function wrap_360(angle)
    local res = angle % 360
    if res < 0 then
      res = res + 360
    end
    return res
end

function wrap_360(angle)
    local res = angle % 360
    if res < 0 then
      res = res + 360
    end
    return res
end



function update()
    -- Get current heading
    local yaw_deg = wrap_360(math.deg(ahrs:get_yaw()))
    local this_alt = baro:get_altitude()
    local dist = ahrs:get_relative_position_NED_home()
    if dist then
        ahrs_altitude = -1*dist:z() -- convert from down to up
    end

    -- Check if the vehicle is armed
    if not is_armed and arming:is_armed() then
        -- Quad just got armed
        is_armed = true
        initial_heading = yaw_deg  -- Store the initial heading
        arm_message = string.format("Quadcopter armed. We see baro:get_altitude as %f and ahrs alt as %f", this_alt, ahrs_altitude)
        -- gcs:log(arm_message)
        gcs:send_text(6, arm_message)
    elseif is_armed and not arming:is_armed() then
        -- Quad got disarmed
        is_armed = false
        e_stop_activated = false
        disarm_message = string.format("Quadcopter disarmed, baro:get_altitude as %f and ahrs alt as %f", this_alt, ahrs_altitude)
        -- gcs:log(disarm_message)
        gcs:send_text(6, disarm_message)
        RC7:set_override(CLEAR_OVERRIDE)  -- Ensure override is cleared
    end

    -- Check heading deviation
    if is_armed then
        if ahrs_altitude > START_SWOON then
            gcs:send_text(6, "alt deviation exceeded! Engaging E-stop.")
            RC7:set_override(ENGAGE_ESTOP)
            e_stop_activated = true
        end

        -- Disengage E-stop if heading deviation is back within tolerance
        if ahrs_altitude < SAVE_YOURSELF and e_stop_activated then
            gcs:send_text(6, "alt restored. Disengaging E-stop.")
            RC7:set_override(CLEAR_OVERRIDE)
            e_stop_activated = false
        end
    end

    -- Run this function at 10Hz
    return update, 100
end

return update()
