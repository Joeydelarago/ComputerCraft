BaseTurtle = {x=0, y=0, z=0, direction=0, 
job=nil, task=nil, 
maxDigAttempts=10, digWait=.5, 
fuelItem = 'minecraft:charcoal', refuelCount=16, args = {}}



--Digging

function BaseTurtle:digForward()
    --Attempts to clear in front of turtle and move forward
    --returns false if block can't be cleared in maxDigAttepts
    local digAttemtps = 0

    while turtle.detect() do
        -- Digs multiple times in case of gravel
        turtle.dig()
        os.sleep(digWait)
        digAttemtps = digAttemtps + 1

        if digAttemtps > self.maxDigAttempts then
            return false
        end
    end

    return true
end


function BaseTurtle:digDown()
    return turtle.digDown()
end

function BaseTurtle:digUp()
    local digAttemtps = 0

    while turtle.detectUp() do
        -- Digs multiple times in case of gravel
        turtle.digUp()
        os.sleep(digWait)
        digAttemtps = digAttemtps + 1

        if digAttemtps > self.maxDigAttempts then
            return false
        end
    end

    return true
end


function BaseTurtle:digMoveForward()
    self:digForward()
    return self:moveForward()
end

function BaseTurtle:digMoveUp()
    self:digUp()
    return self:moveUp()
end

function BaseTurtle:digMoveDown()
    self:digDown()
    return self:moveDown()
end

-- Inventory Management
function BaseTurtle:selectSlotItem(itemName)
    for i = 1, 16, 1 do
        turtle.select(i)
        local itemDetail = turtle.getItemDetail()
        if itemDetail and itemDetail.name == itemName then
            return true
        end
    end
    turtle.select(1);
    return false
end

function BaseTurtle:selectEmptySlot()
    for i = 1, 16, 1 do
        turtle.select(i)
        if not turtle.getItemDetail() then
            return true
        end
    end
    turtle.select(1);
    return false
end


function BaseTurtle:depositInventory() 
    for i=1, 16, 1 do
        turtle.select(i)
        local item = turtle.getItemDetail()
        if item and item.name ~= self.fuelItem and item.name ~= 'enderstorage:ender_chest' then
            if not turtle.drop() then
                return false
            end
        end
    end

    return true
end

function BaseTurtle:inventoryEmpty() 
    for i=1, 16, 1 do
        local item = turtle.getItemDetail()
        if item and item.name ~= self.fuelItem and item.name ~= 'enderstorage:ender_chest' then
            return false
        end
    end

    return true
end

function BaseTurtle:inventoryFull() 
    for i=1, 16, 1 do
        if turtle.getItemCount(i) == 0 then
            return false
        end
    end

    return true
end

function BaseTurtle:lastInventorySlotEmpty()
    return turtle.getItemCount(16) == 0
end

function BaseTurtle:refuel()
    if turtle.getFuelLevel() > 800 then
        return true
    end

    while not self:selectSlotItem(self.fuelItem) do
        if not self:getFuelFromEnderChest() then
            print('Failed to fuel')
            os.sleep(10)
        end
    end

    if self:selectSlotItem(self.fuelItem) then
        return turtle.refuel(self.refuelCount)
    end

    return false
end


function BaseTurtle:depositIntoEnderChest() 
    local chest = turtle.getItemDetail(2)
    if not chest or chest.name ~= 'enderstorage:ender_chest' then
        print('Failed to deposit in ender chest')
        return false
    end

    turtle.dig()
    turtle.select(2)
    turtle.place()
    self:depositInventory()
    turtle.select(2)
    turtle.dig()
    turtle.select(1)

    return true
end

function BaseTurtle:getFuelFromEnderChest()
    local chest = turtle.getItemDetail(2)
    if not chest or chest.name ~= 'enderstorage:ender_chest' then
        print('Failed te withraw fuel from ender chest')
        return false
    end

    local withdrawAmount = 64
    if self:selectSlotItem(self.fuelItem) then 
        withdrawAmount = withdrawAmount - turtle.getItemDetail().count
    else
        self:selectEmptySlot() 
    end

    turtle.dig()
    turtle.place()
    turtle.suck(withdrawAmount)
    turtle.select(1)
    turtle.dig()

    if not self:selectSlotItem(self.fuelItem) then
        return false
    end

    return true
end

function BaseTurtle:verifyCorrectInventory()
    local item1 = turtle.getItemDetail(1)
    local item2 = turtle.getItemDetail(2)
    if item1 and item1.name == 'enderstorage:ender_chest' and item2 and item2.name == 'enderstorage:ender_chest' then
        return true
    end

    print("Item slot 1 must be fuel ender chest, Item slot 2 must be item depsit ender chest")
    return false
end

-- Turning
function BaseTurtle:turnRight(count)
    for i=1, count, 1 do
        self:updateDirection(1)
        turtle.turnRight()
    end
end

function BaseTurtle:turnLeft(count)
    for i=1, count, 1 do
        self:updateDirection(-1)
        turtle.turnLeft()
    end
end

function BaseTurtle:turn(dir)
    while dir ~= self.direction do
        self:turnRight(1)
    end
end

-- Moving
function BaseTurtle:moveForward()
    if turtle.forward() then
        self:updateLocation()
        return true
    end
    return false
end

function BaseTurtle:moveUp()
    if turtle.up() then
        self:updateLocationZ(1)
        return true
    end
    return false
end

function BaseTurtle:moveDown()
    if turtle.down() then
        self:updateLocationZ(-1)
        return true
    end
    return false
end

function BaseTurtle:moveDirection(dir)
    self:turn(dir)
    return self:moveForward()
end

-- Inspecting


-- XYZ Utils

function BaseTurtle:setCoordinates()
    local x, y, z = gps.locate(5)

    if not x then
        print('Failed to locate gps, defaulting to 0, 0, 0')
    else
        self.x = x
        self.y = y
        self.z = z
    end

    self:digForward()
    self:MoveForward()
    local x2, y2, z2 = gps.locate(5)

    if x2 > x then
        self.direction = 0
    elseif y2 > y then
        self.direction = 1
    elseif x2 < x then
        self.direction = 2
    elseif y2 < y then
        self.direction = 3
    end
end

function BaseTurtle:getLeftCoordinate()
    if (self.direction == 0) then
        return {x=self.x, y=self.y - 1}
    elseif (self.direction == 1) then
        return {x=self.x + 1, y=self.y}
    elseif (self.direction == 2) then
        return {x=self.x, y=self.y + 1}
    elseif (self.direction == 3) then
        return {x=self.x - 1, y=self.y}
    end
end

function BaseTurtle:getRightCoordinate()
    if (self.direction == 0) then
        return {x=self.x, y=self.y + 1}
    elseif (self.direction == 1) then
        return {x=self.x - 1, y=self.y}
    elseif (self.direction == 2) then
        return {x=self.x, y=self.y - 1}
    elseif (self.direction == 3) then
        return {x=self.x + 1, y=self.y}
    end
end


function BaseTurtle:returnHome()
end

-- Updating State

function BaseTurtle:updateLocation()
    if (self.direction == 0) then
        self.x = self.x + 1
    elseif (self.direction == 1) then
        self.y = self.y + 1
    elseif (self.direction == 2) then
        self.x = self.x - 1
    elseif (self.direction == 3) then
        self.y = self.y - 1
    end
end

function BaseTurtle:updateLocationZ(dir)
    self.z = self.z + dir
end

function BaseTurtle:updateDirection(amount)
    self.direction = math.abs(((self.direction + amount) + 4) % 4)
end

function BaseTurtle:new (o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

return BaseTurtle