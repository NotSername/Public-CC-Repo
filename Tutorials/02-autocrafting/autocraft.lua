-- autocraft.lua
-- A minimal autocrafter: pulls planks from a chest, crafts sticks, deposits them.
--
-- GIVE YOUR TURTLE A CRAFTING TABLE USING turtle.equipLeft() or turtle.equipRight()
-- whilst a crafting table is in its selected slot.
--
-- Setup: place a chest on one side of the turtle (default: "front") containing
-- minecraft:planks (any wood type). Run the program.

-- NOTE: turtle.suck() always pulls from whatever is directly in FRONT of the
-- turtle. Use turtle.suckUp() / turtle.suckDown() for chests above/below.
-- There is no "suck from the side" ? turtles don't have side-facing inventory
-- access, so physically face the turtle at your chest before running this.
local SUCK_FN = turtle.suck

-- Recipe definition: which turtle grid slot gets which item.
-- Sticks recipe: 2 planks stacked vertically in the middle column.
local STICK_RECIPE = {
    [2] = "minecraft:planks", -- top-middle
    [6] = "minecraft:planks", -- middle-middle
}

local function clearGrid()
    -- Crafting slots only; leave 4, 8, 12-16 alone
    local gridSlots = {1, 2, 3, 5, 6, 7, 9, 10, 11}
    for _, slot in ipairs(gridSlots) do
        turtle.select(slot)
        -- Drop back into the chest if there's leftover stuff in the grid
        turtle.drop()
    end
end

local function pullIngredient(itemName, intoSlot)
    -- Search the turtle's own inventory first (slots 13-16, "storage" slots)
    -- but for this simple example we just suck directly from the chest.
    turtle.select(intoSlot)
    local pulled = false

    -- suck() pulls from whatever inventory is in front of the turtle
    -- We loop a few times in case the matching item isn't the first one suck() grabs.
    for attempt = 1, 8 do
        local ok = SUCK_FN(1)
        if ok then
            local detail = turtle.getItemDetail(intoSlot)
            if detail and detail.name == itemName then
                pulled = true
                break
            else
                -- wrong item ended up in our slot; put it back and try again
                turtle.drop()
            end
        end
    end

    return pulled
end

local function craftSticks()
    clearGrid()

    for slot, itemName in pairs(STICK_RECIPE) do
        local ok = pullIngredient(itemName, slot)
        if not ok then
            error("Could not pull " .. itemName .. " into slot " .. slot .. ". Check chest contents.")
        end
    end

    turtle.select(1)
    local success, reason = turtle.craft()
    if not success then
        error("Crafting failed: " .. tostring(reason))
    end

    print("Crafted sticks successfully!")

    -- Deposit the crafted result back into the chest
    for slot = 1, 16 do
        turtle.select(slot)
        turtle.drop()
    end
end

-- --- Main ---
print("Make sure the turtle is facing the chest with the planks.")
print("Attempting to craft sticks from planks...")
craftSticks()
