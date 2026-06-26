# 02 - Autocrafting

![image](https://github.com/NotSername/Public-CC-Repo/blob/main/images/13.jpg?raw=false)

Build a system that takes a recipe definition and automatically crafts items
using a turtle's built-in 3x3 crafting grid.

## Requirements

- A **Turtle** equipped with a crafting table.
- A chest **directly in front of** the turtle, stocked with crafting ingredients (e.g. planks)
  - `turtle.suck()` only pulls from whatever is in front of the turtle, there's no
    sideways suck. Use `turtle.suckUp()` / `turtle.suckDown()` if your chest is above/below instead.
- CC: Tweaked

## Core Concepts

### The turtle's crafting grid

A turtle has 16 inventory slots. Slots **1, 2, 3, 5, 6, 7, 9, 10, 11** map to
a 3x3 crafting grid (slots 4, 8, 12-16 are unused padding/output space).

```
[1][2][3]
[5][6][7]
[9][10][11]
```

### Crafting

```lua
turtle.select(1)         -- selects where the *output* will try to stack, doesn't matter much here
local ok, reason = turtle.craft()
if not ok then
    print("Craft failed: " .. reason)
end
```

`turtle.craft()` looks at whatever is currently sitting in the 3x3 grid
slots and tries to craft it, exactly like a player would in a crafting table.

### The general pattern

1. Define a **recipe** as a Lua table: which item goes in which of the 9 grid slots
2. **Pull** the right items from a chest into the right turtle slots
3. Call `turtle.craft()`
4. **Push** the result back into a chest

This is the same shape every autocrafter uses. They just add a queue, a recipe database, and recursive
sub-crafting (crafting the ingredients of your ingredients) on top.

## What the example program does

`autocraft.lua` defines one hard-coded recipe (sticks, from planks) as a
grid layout, pulls the needed planks from a chest directly in front of the
turtle, crafts the sticks, and deposits them back into that same chest.
It's deliberately simple. one recipe, no recursion, so the pattern is
easy to see before scaling up.

## Try it yourself next

- Make the recipe table support *multiple* recipes, keyed by result name
- Write a `craftItem(name, count)` function that loops the recipe until enough are made
- Add recursive crafting: if an ingredient is missing, check if *it* has a recipe too, and craft that first
- Hook this up to the inventory scanner from module 01 to auto-detect what's missing

## Free.99 tips.

Using plethora's introspection module you can use `modem.getNameLocal()` to use .pushItem() / .pullItem() of which the usage is explained in `01 - inventory systems`
