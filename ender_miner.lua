local BaseTurtle = require('base_turtle')

EnderMiner = BaseTurtle:new{tunnelWidth=50, tunnelHeight=3, startDirection=0, rowNum=0}

function EnderMiner:start()
    if not self:verifyCorrectInventory() or not self:refuel() then
        return false
    end

    while true do
        self:moveToNextRow()
        self:mineTunnel()
        self:depositIntoEnderChest()
        self:refuel()
        self.rowNum = self.rowNum + 1
    end

end

function EnderMiner:checkItems()
end

function EnderMiner:moveToNextRow()
    self:turn(self.startDirection)
    self:digMoveForward()
    self:digMoveForward()
    self:digMoveForward()

    -- Turn right on even rows and left on odd rows
    if self.rowNum % 2 == 0 then
        self:turnLeft(1)
    else
        self:turnRight(1)
    end
end

function EnderMiner:mineTunnel()
    for i=1, self.tunnelWidth, 1 do
        self:digSlice(self.tunnelHeight)
        if i ~= self.tunnelWidth then
            self:digMoveForward()
        end
    end
end

function EnderMiner:digSlice(height)
    --Dig left side
    self:turnLeft(1)
    for i=1, height - 1, 1 do
        self:digForward()
        self:digMoveUp()
    end
    self:digForward()

    --Dig right side
    self:turnRight(2)
    for i=1, height - 1, 1 do
        self:digForward()
        self:digMoveDown()
    end
    self:digForward()

    self:turnLeft(1)
end

local enderMiner = EnderMiner:new()
enderMiner:start()