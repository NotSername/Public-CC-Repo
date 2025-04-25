local GUI = {}

local Menus = {}
local CurrentMenu = nil
local Buttons = {}
local selectedButton = 1

function GUI.addMenu(name)
    Menus[name] = {}
end

function GUI.renameButton(menuName, oldName, newName)
    if not Menus[menuName] then
        error("Menu '" .. menuName .. "' does not exist!")
    end

    for _, button in ipairs(Menus[menuName]) do
        if button.name == oldName then
            button.name = newName
            if menuName == CurrentMenu then
                GUI.render()
            end
            return true
        end
    end

    return false
end

function GUI.centerText(txt, y)
    local w = term.getSize()
    local x = math.floor((w - #txt) / 2) + 1
    if y then
        term.setCursorPos(x, y)
    else
        local _, currentY = term.getCursorPos()
        term.setCursorPos(x, currentY)
    end
    term.write(txt)
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

