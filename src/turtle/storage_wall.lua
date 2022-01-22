local BaseTurtle = require('base_turtle')
local args = { ... }

StorageWall = BaseTurtle:new{width=0, height=0}


function StorageWall:start()
    if not args[1] or not args[2] then
        print("Please unput width and height")
    end

    self.width = args[1]
    self.height = args[2]

    while true do
        self:turnRight()
        self:refuel()
        self:turnLeft()
        self:fillInventory()
        self:storeItems()
        self:returnToQueue()
    end
end

function StorageWall:returnToQueue()
    while self.y > - 1 do
        if not self:moveDirection(3) then
            print('Cant move forward')
            os.sleep(5)
        end
    end

    while self.z > 0 do
        if not self:moveDown() then
            print('Cant move down')
            os.sleep(5)
        end
    end

    while self.x < 0 do
        if not self:moveDirection(0) then
            print('Cant move forward')
        end
    end

    self:turn(1)

    while turtle.detect() do
        os.sleep(5)
        print('Wating to get items')
    end

    self:moveForward()
    self:turnLeft()
end

function StorageWall:storeItems() 
    self:turnRight(1)

    for i = 1, self.width, 1 do
        self:turnRight(1)
        self:moveForward()
        self:turnLeft(1)
        for j = 1, self.height - 1, 1 do
            self:depositInventory()
            if i % 2 == 0 then
                self:moveDown()
            else 
                self:moveUp()
            end
        end

        if self:inventoryEmpty() then
            return
        end
    end
end

function StorageWall:fillInventory()
    for i = 2, 16, 1 do
        turtle.select(i)
        turtle.suck()
        while not turtle.getItemDetail() do
            os.sleep(5)
            print('no items to sort')
            turtle.suck()
        end
    end
end

local storageWall = StorageWall:new()
storageWall:start()