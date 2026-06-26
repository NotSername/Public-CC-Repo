# ComputerCraft Tutorial

![image](https://github.com/NotSername/Public-CC-Repo/blob/main/images/8.webp?raw=false)

A hands-on tutorial for [CC: Tweaked](https://tweaked.cc/), covering
inventory systems, autocrafting, talking to local LLMs, using AI as a coding
aid, and turtle automation (including building structures from blueprints).

Each numbered folder is a standalone lesson: a `README.md` explaining the
concepts, and one runnable `.lua` example.

## Lessons

| # | Topic | Folder |
|---|-------|--------|
| 1 | Inventory Systems | [`01-inventory-systems/`](./01-inventory-systems) |
| 2 | Autocrafting | [`02-autocrafting/`](./02-autocrafting) |
| 3 | Interfacing with AI | [`03-ai-interfacing/`](./03-ai-interfacing) |
| 4 | Using AI to Write Lua | [`04-ai-assisted-lua/`](./04-ai-assisted-lua) |
| 5 | Turtles: The Basics | [`05-turtles-basics/`](./05-turtles-basics) |
| 6 | Turtles Building Structures | [`06-turtle-building/`](./06-turtle-building) |

## Suggested order

1 → 2 (inventory systems are the foundation autocrafting builds on)
5 → 6 (turtle basics before structure-building)
3 and 4 can be read any time, they're independent of the others.

## Requirements

- Minecraft with [CC: Tweaked](https://www.curseforge.com/minecraft/mc-mods/cc-tweaked) installed

## How to use the example code

Each `.lua` file is meant to be copied onto a CC: Tweaked computer or turtle.
The usual ways to get code onto one in-game:

- Type it directly using the in-game computer terminal and `edit <filename>`
- Use `wget` (can be used with raw github source)
- Use a tool like [Cloud Catcher](https://github.com/SquidDev-CC/cloud-catcher) to sync from your actual filesystem
- Use `pastebin` it's last on the list for a reason, i hate it.

Read the README in each folder before running its script, most need a
specific setup (chest placement, fuel, items in specific slots) to work.
