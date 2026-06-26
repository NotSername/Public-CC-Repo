# 01 - Inventory Systems

![image](https://github.com/NotSername/Public-CC-Repo/blob/main/images/12.jpg?raw=false)

Learn how to read, move, and track items across multiple chests/barrels using
CC: Tweaked peripherals. the foundation of every storage system you'll ever build.

## Requirements

- CC: Tweaked (any recent version)
- 1 Computer (Advanced Computer recommended, but a normal one works)
- A Wired Modem on the computer + a Wired Modem on each chest/barrel you want
  to connect, OR just place chests directly adjacent to the computer (no modem needed for direct-adjacent peripherals)
- A few chests/barrels with some items in them for testing

## Core Concepts

### Wrapping a peripheral

Every inventory (chest, barrel, shulker box) is a **peripheral**. You access
it either by the side it's on, or by its network name if it's connected via
wired modem.

```lua
local chest = peripheral.wrap("right")
```

If it's on a wired network, names look like `"minecraft:chest_3"`. You can
list everything currently visible with:

```lua
print(textutils.serialize(peripheral.getNames()))
```

### Listing items

```lua
local items = chest.list()
-- items is a table: { [slot] = {name="minecraft:cobblestone", count=64}, ... }
```

### Finding inventories at once

This is the single most useful function for building a storage system:

```lua
local inventories = {peripheral.find("<block>")}
```

For example,

```lua
local inventories = {peripheral.find("minecraft:ironchest_diamond")}
```

This returns every connected peripheral that has the name minecraft:ironchest_diamond (Diamond Chest).
If you're unsure about the name, right click a modem that's placed onto the block and it'll show you the name.

### Moving items

```lua
-- chest1.pushItems(targetName, fromSlot, [limit], [toSlot])
chest1.pushItems(peripheral.getName(chest2), 1, 10)
```

`pushItems` is called **on the source**, and takes the **name** of the
target peripheral (a string), not the wrapped object itself. That's the
most common mistake beginners make here. (This works across modems.)

For example:
```lua
a = peripheral.wrap("minecraft:ironchest_diamond_1")
b = peripheral.wrap("minecraft:ironchest_diamond_1")

a.pushItems(peripheral.getName(b), 1, 1)
```

This pushes 1 item from slot 1 of chest A to chest B

## What the example program does

`storage_scan.lua` connects to every **diamond chest** peripheral it can find,
totals up every item type across all of them, and prints a sorted summary.
Basically a tiny "what do I have in storage" report. This is the seed of
every bigger storage system (just swap the `print` at the end for pushing
items somewhere, or for a monitor UI).

## Try it yourself next

- Make it refresh every 2 seconds and display on a monitor (`peripheral.find("monitor")`)
- Add a search function: `findItem("minecraft:diamond")` that returns which chest + slot it's in
- Add a `deposit(itemName, count)` / `withdraw(itemName, count)` pair of functions
