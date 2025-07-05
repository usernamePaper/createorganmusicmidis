local basalt = require("basalt")
local files = fs.list("/music/")
local debug_mode = 1

if debug_mode == 1 then
    for i = 1, #files do
        print(files[i])
    end
    sleep(1)
end

shell.run("clear")

local main = basalt.getMainFrame()
main:clear()

main:addLabel()
    :setText("welcome to EzM!")
    :setForeground(colors.blue)
    :setPosition(1,1)    
for i = 1, #files do

    main:addButton()
        :setText("test")
        :setPosition(2,i * 4)
        :onClick(function()
        
        basalt.stop()
        shell.execute("/play", fs.combine("/music/", fs.getName(files[i])))
        
        end)
        
end

basalt.run()
