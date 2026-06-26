-- blueprint_builder.lua
-- A generic blueprint executor: give it a 3D table of 1s and 0s, and it
-- snakes through it (boustrophedon path) placing blocks below itself as
-- it moves, then climbs to the next layer.
--
-- Coordinate model:
--   blueprint[y][z][x]   -- y = layer (bottom to top), z = row, x = column
--   1 = place a block here, 0 = skip
--
-- The turtle PLACES DOWN as it travels, one row above the layer it's
-- building, so it never has to dig through what it just placed.
--
-- Setup: clear flat area in front of the turtle, oak planks in slot 1.

-- A small boat-shaped hull: layer 1 is a solid-ish base, layer 2 raises
-- the sides only, leaving the middle open (like a hull cross-section).
local blueprint = {
    -- Layer 1 (bottom / keel)
    {
        {0, 1, 1, 1, 0},
        {1, 1, 1, 1, 1},
        {0, 1, 1, 1, 0},
    },
    -- Layer 2 (sides only, open middle)
    {
        {1, 1, 1, 1, 1},
        {1, 0, 0, 0, 1},
        {1, 1, 1, 1, 1},
    },
}

local BUILD_MATERIAL_SLOT = 1

local function ensureMaterial()
    turtle.select(BUILD_MATERIAL_SLOT)
    local detail = turtle.getItemDetail(BUILD_MATERIAL_SLOT)
    if not detail then
        error("Slot " .. BUILD_MATERIAL_SLOT .. " is empty. Put building material there.")
    end
    return detail.count
end

-- Places a block below the turtle's current position, if the blueprint
-- calls for one. The turtle travels ONE block above the layer it's
-- building, so placeDown() lands the block at the correct layer height.
local function placeIfNeeded(code)
    if code == 1 then
        turtle.select(BUILD_MATERIAL_SLOT)
        if turtle.detectDown() then
            return -- already a block there, nothing to do
        end
        local ok = turtle.placeDown()
        if not ok then
            error("Failed to place block — out of material, or something is blocking placement.")
        end
    end
end

-- Moves forward, digging first if something is in the way
-- (useful for re-running a partially built structure).
local function stepForward()
    if turtle.detect() then
        turtle.dig()
        sleep(0.2)
    end
    local moved = turtle.forward()
    if not moved then
        error("Couldn't move forward — check for obstacles or entities.")
    end
end

-- Builds a single layer using a boustrophedon (snake) path.
-- Returns whether the layer ended on a left-to-right pass (true) or a
-- right-to-left pass (false) — needed by returnToLayerStart to know
-- where the turtle physically ended up.
local function buildLayer(layer)
    local rowCount = #layer
    local goingRight = true -- tracks current snake direction

    for z = 1, rowCount do
        local row = layer[z]
        local colCount = #row

        for x = 1, colCount do
            local col = goingRight and x or (colCount - x + 1)
            placeIfNeeded(row[col])

            local isLastInRow = (x == colCount)
            if not isLastInRow then
                stepForward()
            end
        end

        local isLastRow = (z == rowCount)
        if not isLastRow then
            -- Turn to face the next row, step into it, turn to face along it
            if goingRight then
                turtle.turnRight()
                stepForward()
                turtle.turnRight()
            else
                turtle.turnLeft()
                stepForward()
                turtle.turnLeft()
            end
            goingRight = not goingRight
        end
    end

    return goingRight
end

-- Returns the turtle to directly above the layer's starting corner,
-- undoing the snake path it just walked, so the next layer starts clean.
--
-- Facing convention used here: the turtle starts buildBlueprint() facing
-- some direction we call "right" (+x). turnRight()/turnLeft() are real
-- 90-degree turns. We track facing explicitly as one of
-- "right", "down" (+z), "left" (-x), "up" (-z) so the return path is
-- correct regardless of how many rows there were.
local function turnTo(currentFacing, targetFacing)
    local order = {"right", "down", "left", "up"} -- clockwise order
    local fromIdx, toIdx
    for i, dir in ipairs(order) do
        if dir == currentFacing then fromIdx = i end
        if dir == targetFacing then toIdx = i end
    end
    local diff = (toIdx - fromIdx) % 4
    if diff == 1 then
        turtle.turnRight()
    elseif diff == 2 then
        turtle.turnRight()
        turtle.turnRight()
    elseif diff == 3 then
        turtle.turnLeft()
    end
    -- diff == 0 means already facing the right way, no turn needed
    return targetFacing
end

local function returnToLayerStart(layer, endedGoingRight)
    local rowCount = #layer
    local lastRow = layer[rowCount]
    local colCount = #lastRow

    -- Facing when buildLayer finished: "right" if it ended on a
    -- left-to-right pass, "left" if it ended on a right-to-left pass.
    local facing = endedGoingRight and "right" or "left"

    -- If the layer ended on a left-to-right pass, the turtle is sitting
    -- at the FAR column (x = colCount) and needs to walk back to x = 1.
    -- If it ended on a right-to-left pass, it's already at x = 1 —
    -- no horizontal movement needed, just a turn.
    if endedGoingRight then
        facing = turnTo(facing, "left")
        for _ = 1, colCount - 1 do
            stepForward()
        end
    end

    -- Walk back up through the rows to row 1 (rows increase in the
    -- "down" direction, so go "up" rowCount-1 times).
    facing = turnTo(facing, "up")
    for _ = 1, rowCount - 1 do
        stepForward()
    end

    -- Restore original orientation ("right") for the next layer.
    turnTo(facing, "right")
end

local function buildBlueprint(bp)
    ensureMaterial()
    print("Starting build: " .. #bp .. " layer(s).")

    for y, layer in ipairs(bp) do
        print("Building layer " .. y .. "/" .. #bp .. "...")

        -- Move up so we're one block above this layer before placing down into it
        turtle.up()

        local endedGoingRight = buildLayer(layer)
        returnToLayerStart(layer, endedGoingRight)
    end

    print("Build complete!")
end

-- --- Main ---
buildBlueprint(blueprint)
