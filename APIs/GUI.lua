
--[[

Simple GUI API since we hate GUIs

Here some example code

-------------------------------------------------------------------------------
local GUI = require("GUI")

GUI.addMenu("Main")
GUI.addMenu("Settings")

GUI.addButton("Main", "Play", 2, 2, 10, 3, function() print("Playing!") end)
GUI.addButton("Main", "Settings", 2, 4, 10, 5, function()
    GUI.setMenu("Settings")
end)
GUI.addButton("Main", "Exit", 2, 6, 10, 7, function() os.exit() end)

GUI.addButton("Settings", "Back", 2, 2, 10, 3, function()
    GUI.setMenu("Main")
end)
GUI.addButton("Settings", "Toggle Sound", 2, 4, 10, 5, function()
    print("Sound toggled!")
end)

GUI.setMenu("Main")
GUI.render()
GUI.start()
-------------------------------------------------------------------------------
--]]

local GUI = {}

local Menus = {}
local CurrentMenu = nil
local Buttons = {}
local selectedButton = 1

function GUI.addMenu(name)
    Menus[name] = {}
end

function GUI.addButton(menu, name, x1, y1, x2, y2, func)
    if not Menus[menu] then
        error("Menu '" .. menu .. "' does not exist!")
    end
    table.insert(Menus[menu], {name = name, x1 = x1, y1 = y1, x2 = x2, y2 = y2, func = func})
end

function GUI.setMenu(menu)
    if not Menus[menu] then
        error("Menu '" .. menu .. "' does not exist!")
    end
    CurrentMenu = menu
    selectedButton = 1
    GUI.render()
end

function GUI.render()
    term.clear()
    for index, button in ipairs(Menus[CurrentMenu]) do
        term.setCursorPos(button.x1, button.y1)
        if index == selectedButton then
            term.setBackgroundColor(colors.orange)
        else
            term.setBackgroundColor(colors.black)
        end
        print("[" .. button.name .. "]")
        term.setBackgroundColor(colors.black)
    end
end

function GUI.start()
    while true do
        local event, p1, p2, p3 = os.pullEvent()

        if event == "mouse_click" then
            local x, y = p2, p3
            for index, button in ipairs(Menus[CurrentMenu]) do
                if math.min(button.x1, button.x2) <= x and x <= math.max(button.x1, button.x2) and
                   math.min(button.y1, button.y2) <= y and y <= math.max(button.y1, button.y2) then
                    selectedButton = index
                    GUI.render()
                    button.func()
                end
            end
        elseif event == "key" then
            local key = p1
            if key == keys.up then
                if selectedButton > 1 then
                    selectedButton = selectedButton - 1
                    GUI.render()
                end
            elseif key == keys.down then
                if selectedButton < #Menus[CurrentMenu] then
                    selectedButton = selectedButton + 1
                    GUI.render()
                end
            elseif key == keys.enter then
                local button = Menus[CurrentMenu][selectedButton]
                if button then
                    button.func()
                end
            end
        end
    end
end


return GUI

