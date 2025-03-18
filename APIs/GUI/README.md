## **Simple GUI API since we hate GUIs**

![image](https://github.com/NotSername/Public-CC-Repo/blob/main/images/5.gif?raw=false)

Here some example code
```md
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
```
