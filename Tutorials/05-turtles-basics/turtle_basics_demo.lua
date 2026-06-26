-- turtle_basics_demo.lua
-- Digs a straight tunnel of TUNNEL_LENGTH blocks, then returns to start.
-- A "hello world" for turtle movement, digging, and fuel checks.

local TUNNEL_LENGTH = 10

local function checkFuel()
    local fuel = turtle.getFuelLevel()

    print("Current fuel: " .. fuel)
    if fuel < TUNNEL_LENGTH * 2 then -- *2 because we need to come back too
        print("Fuel might be too low for a round trip. Trying to refuel from slot 1...")
        turtle.select(1)
        local refueled = turtle.refuel()
        if not refueled then
            print("Could not refuel. Put coal/charcoal/fuel in slot 1 and try again.")
            return false
        end
        print("Refueled. New level: " .. turtle.getFuelLevel())
    end
    return true
end

-- Digs forward repeatedly until the way is clear, then moves.
-- Handles the gravel/sand case where digging once isn't enough
-- because more material falls into the space immediately after.
local function digAndMoveForward()
    local attempts = 0
    while turtle.detect() do
        turtle.dig()
        attempts = attempts + 1
        sleep(0.4) -- brief pause helps with falling blocks (gravel/sand)
        if attempts > 10 then
            error("Something keeps blocking the path after 10 dig attempts.")
        end
    end

    local moved = turtle.forward()
    if not moved then
        error("Couldn't move forward even though no block was detected. Possible entity in the way?")
    end
end

local function digTunnel(length)
    for i = 1, length do
        digAndMoveForward()
        print("Progress: " .. i .. "/" .. length)
    end
end

local function returnToStart(length)
    turtle.turnLeft()
    turtle.turnLeft() -- now facing back the way we came

    for i = 1, length do
        -- On the way back the path is already clear, but dig just in case
        -- something (e.g. a mob, or new gravel) is now blocking it.
        digAndMoveForward()
    end

    turtle.turnLeft()
    turtle.turnLeft() -- face original direction again
end

-- --- Main ---
print("=== Turtle Basics Demo ===")
print("Tunnel length: " .. TUNNEL_LENGTH)

if not checkFuel() then
    return
end

print("Digging tunnel...")
digTunnel(TUNNEL_LENGTH)

print("Reached the end. Returning to start...")
returnToStart(TUNNEL_LENGTH)

print("Done! Back at starting position, facing original direction.")
