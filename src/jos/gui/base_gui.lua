-- Gui elemens are drawn in 
local w, h = term.getSize()
BaseGui = {children={}, x1=0, y1=0, x2=5, y2=5, width=w-1, height=h-1}

function BaseGui:draw()
    self:drawChildren()
    self:renderGui()
end

function BaseGui:drawChildren()
    for _, gui in pairs(self.children) do
        gui.draw()
    end
end

function BaseGui:renderGui()
    -- Default render option to show gui nodes on creation
    paintutils.drawBox(self.x1, self.y1, self.x2, self.y2, colors.green)
    term.write("width: "..self.width)
    term.write(" height: "..self.height)
end

function BaseGui:new (o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

return BaseGui