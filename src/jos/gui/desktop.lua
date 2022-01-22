local BaseGui = require(JOS_ROOT..'gui/base_gui')

DeskTop = BaseGui:new{}

function DeskTop:run()
    self:clear()
    self:draw()
end

function DeskTop:new (o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function DeskTop:clear()
    term.clear()
end

function DeskTop:renderGui()
    paintutils.drawFilledBox(0, 0, self.width, self.height, colors.blue)
    self:drawTime()
end

function DeskTop:drawTaskBar()
    local h = self.height/10 
end

function DeskTop:drawTime()
    local h = 1
    local w = 10
    local box_y = self.height - h
    local box_x = self.width - w
    paintutils.drawFilledBox(box_x, box_y, self.width, self.height, colors.green)

    term.setCursorPos(box_x, box_y)

    local time = os.time()
    local formattedTime = textutils.formatTime(time, false)
    term.write(formattedTime)
end

return DeskTop
