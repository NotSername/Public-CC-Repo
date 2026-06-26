# 06 - Turtles Building Structures (Blueprints)

![image](https://github.com/NotSername/Public-CC-Repo/blob/main/images/14.jpg?raw=false)

The "can a turtle build a boat?" module. The answer is yes and the trick
is to separate **what to build** (a data structure) from **how to build it**
(a generic movement + placement engine you write once and reuse forever).

## Requirements

- A turtle with an empty inventory slot setup matching the example's
  material list (see comments in the `.lua` file)
- A flat, clear build area in front of the turtle
- Building materials in the turtle's inventory (the demo uses oak planks)

## Core Concepts

### Separate data from code

Instead of hardcoding "place a block, move forward, place a block...", you
define the structure as a 3D table. layers (Y), each a grid of rows (Z) and
columns (X):

```lua
local blueprint = {
    -- Layer 1 (y = 0)
    {
        {1, 1, 1},
        {1, 0, 1},
        {1, 1, 1},
    },
    -- Layer 2 (y = 1)
    {
        {1, 0, 1},
        {0, 0, 0},
        {1, 0, 1},
    },
}
```

`1` means "place a block here," `0` means "skip / leave air." A generic
builder function can then walk through *any* blueprint table like this and
build it meaning the same code builds a boat, a house, or pixel art, just
by swapping the table.

### The movement problem: boustrophedon ("snake") paths

The naive approach go to each block, then return to a fixed origin before
moving to the next one wastes huge amounts of fuel and time. The standard
solution is a **boustrophedon path**: snake back and forth, row by row, only
turning at the ends of rows:

```
Row 1: → → → →
Row 2: ← ← ← ←   (turtle turns around at the end of row 1, then goes back)
Row 3: → → → →
```

This means tracking which direction the turtle is currently moving in each
row, and alternating it.

### Layer-by-layer

After finishing a full layer (all rows, all columns), the turtle moves up
(`turtle.up()`) and repeats for the next Y layer, ideally ending each layer
at a position where it's easy to start the next.

## What the example program does

`blueprint_builder.lua` defines a small boat-shaped blueprint (a simple hull
with raised sides not a literal Minecraft boat item, an actual built
structure) and a **generic blueprint executor**: it snakes through every
layer, placing blocks where the blueprint says `1`, skipping `0`s, and
returns to roughly the starting corner when finished.

It uses a single material (planks) in this demo for simplicity, but the
material per-block-type slot mapping is structured so you can extend it to
multiple materials.

## Try it yourself next

- Add a second material code (e.g. `2` = a different block) and have the
  builder select different inventory slots based on the code
- Add a check at the start that verifies the turtle has enough blocks total
  before starting (count the 1s and 2s in the blueprint vs. inventory)
- Try designing a *real* boat hull shape (wider in the middle, narrower at
  the bow/stern) as a blueprint table and see if the engine handles it
  without any code changes, that's the whole point of the data/code split
