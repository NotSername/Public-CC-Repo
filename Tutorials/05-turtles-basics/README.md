# 05 - Turtles: The Basics

![image](https://github.com/NotSername/Public-CC-Repo/blob/main/images/9.png?raw=false)

Turtles are mobile, programmable robots: 16 inventory slots, movement in 3D
space, and (depending on equipped tool) the ability to dig, attack, or place
blocks. This module covers the core Turtle API everything else builds on.

## Requirements

- Turtle with a pickaxe equipped.
- Some fuel (coal, charcoal, or any combustible item) in slot 1
- A bit of open space to test movement in

## Core Concepts

### Movement

```lua
turtle.forward()   -- returns true/false
turtle.back()
turtle.up()
turtle.down()
turtle.turnLeft()
turtle.turnRight()
```

All movement functions return `true` on success or `false` (plus a reason
string) if blocked **always check the return value**, don't assume
movement succeeded.

### Digging and placing

```lua
turtle.dig()      turtle.digUp()      turtle.digDown()
turtle.place()    turtle.placeUp()    turtle.placeDown()
```

`place()` uses whatever item is in the **currently selected slot**.

### Inventory

```lua
turtle.select(1)              -- select slot 1 (1-16)
turtle.getItemCount(1)
turtle.getItemDetail(1)        -- returns {name=..., count=...} or nil if empty
turtle.getSelectedSlot()
```

### Detection (without moving or digging)

```lua
turtle.detect()        -- true if a block is directly in front
turtle.detectUp()
turtle.detectDown()
turtle.compare()       -- true if block in front matches the selected item
```

### Fuel

Turtles need fuel to move.

```lua
turtle.getFuelLevel()     -- current fuel
turtle.select(1)           -- select a fuel item, e.g. coal
turtle.refuel()             -- consumes it, adds fuel
```

## What the example program does

`turtle_basics_demo.lua` runs through a guided sequence: checks fuel, digs a
straight 1-block tunnel of a configurable length (re-trying if a block keeps
respawning, like gravel/sand falling), then turns around and walks back to
the starting position. It's intentionally simple a "hello world" for
turtle movement and digging, not a full mining program.

## Try it yourself next

- Modify it to mine a 1x2 tunnel (player height) instead of 1x1
- Make it refuel automatically from a chest if fuel gets low
