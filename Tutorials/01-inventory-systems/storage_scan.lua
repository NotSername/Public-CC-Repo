-- storage_scan.lua
-- Scans every connected peripheral and prints a totals report.
--
-- Setup: place a computer adjacent to (or wired-modem-connected to) one or
-- more chests/barrels with items in them, then run this program.

local storageContainer = "minecraft:ironchest_diamond"

local function getAllInventories()
    local inventories = { peripheral.find(storageContainer) }
    if #inventories == 0 then
        error("No inventory peripherals found. Check wired modem connections.")
    end
    return inventories
end

local function scanTotals(inventories)
    local totals = {}        -- itemName -> count
    local locations = {}      -- itemName -> { {peripheralName, slot, count}, ... }

    for _, inv in ipairs(inventories) do
        local name = peripheral.getName(inv)
        local items = inv.list()

        for slot, item in pairs(items) do
            totals[item.name] = (totals[item.name] or 0) + item.count

            locations[item.name] = locations[item.name] or {}
            table.insert(locations[item.name], {
                peripheral = name,
                slot = slot,
                count = item.count,
            })
        end
    end

    return totals, locations
end

local function printReport(totals)
    -- Sort item names alphabetically for a stable, readable report
    local names = {}
    for name in pairs(totals) do
        table.insert(names, name)
    end
    table.sort(names)

    print("=== Storage Report ===")
    for _, name in ipairs(names) do
        print(string.format("%-35s x%d", name, totals[name]))
    end
    print("=======================")
end

-- Optional: find which chest+slot a specific item is in
local function findItem(locations, itemName)
    return locations[itemName]
end

-- --- Main ---
local inventories = getAllInventories()
print("Found " .. #inventories .. " inventories. Scanning...")

local totals, locations = scanTotals(inventories)
printReport(totals)

-- Example lookup (uncomment to try):
-- local hits = findItem(locations, "minecraft:cobblestone") <-- make sure to keep the block in mind.
-- if hits then
--     for _, hit in ipairs(hits) do
--         print(("Found in %s, slot %d, count %d"):format(hit.peripheral, hit.slot, hit.count))
--     end
-- end
