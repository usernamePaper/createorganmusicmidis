shell.run("clear")
print("ATTENTION! music MUST be placed in /music/")

local basalt = require("basalt")
local files = fs.list("/music/")
local debug_mode = 1

if debug_mode == 1 then
    print("here's list of files in /music/")
    for i = 1, #files do
        print(files[i])
    end
    sleep(1)
end

shell.run("clear")


local main = basalt.getMainFrame()

--- Calculates the height of all visible children in a container.
--- This is used to determine the maximum scrollable height.
local function getChildrenHeight(container)
    local height = 0
    for _, child in ipairs(container.get("children")) do
        if(child.get("visible"))then
            local newHeight = child.get("y") + child.get("height")
            if newHeight > height then
                height = newHeight
            end
        end
    end
    return height
end

--- Creates a scrollable frame that allows scrolling through its children.
--- It listens for scroll events and adjusts the offsetY property accordingly.
local function scrollableFrame(container)
    container:onScroll(function(self, direction)
        local height = getChildrenHeight(self)
        local scrollOffset = self.get("offsetY")
        local maxScroll = height - self.get("height")
        scrollOffset = math.max(0, math.min(maxScroll, scrollOffset + direction))
        self.set("offsetY", scrollOffset)
    end)
end

-- The frame we want to be scrollable
local frame = main:addFrame()
scrollableFrame(frame)

local font = frame:addBigFont()
font:setText("welcome to EzM! by Bedrock Music")

frame:setSize(51,19)
font:addLabel()
    :setText("welcome to EzM! by Bedrock Music")
    :setForeground(colors.blue)
    :setPosition(1,1)
for i = 1, #files do

    frame:addButton()
        :setBackground(colors.white)
        :setForeground(colors.purple)
        :setText(fs.getName(files[i]))
        :setPosition(2,i * 4)
        :setSize(30,3)
        :onClick(function()
        local path = fs.combine("/music", files[i])

        local args = { path }  -- аргументы для новой вкладки

        local env = {
            shell = shell,
            fs = fs,
            os = os,
            term = term,
            multishell = multishell,
            _G = _G,
            arg = args,
            require = require,
        }

        setmetatable(env, { __index = _G })

        local id = multishell.launch(env, "play", table.unpack(args))
        multishell.setTitle(id, "music player")
        end)
        
end

basalt.run()
