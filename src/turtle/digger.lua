local args = { ... }

local x = 0
local y = 0
local z = 0
-- 0 is north
local direction = 0

local refuelCount = 5
local fuelItem = 'minecraft:charcoal'
local tunnelLength = 0;
-- Max amount of times turtle will attempt to dig a block before returning false
local maxDigAttempts = 10;
-- Amount of seconds to wait between digging attempts
local digWait = .5;

function DigOutChunk(chunks)
    for i = 1, 16, 1 do
        DigForward()
    end

    if turtle.detect() then
        Chunk()
    end
end

function Chunk()
    DigForward()
    for i=1, 15, 1 do

        if turtle.getFuelLevel() < 80 then
            if not Refuel() then
                Stop()
            end
        end

        if InventoryFull() then
            StoreInChest()
        end

        for j=1, 15, 1 do
            DigForward()
        end
        Turn(3)
        DigForward()
        if i%2 == 1 then
            Turn(2)
        else
            Turn(0)
        end
    end
end

function StoreInChest()
    while y ~= 0 do
        if y > 0 then
            MoveDirection(3)
        else
            MoveDirection(1)
        end
    end

    Refuel()

    while x ~= 0 do
        if x > 0 then
            MoveDirection(2)
        else
            MoveDirection(0)
        end
    end

    while turtle.inspect().name ~= 'minecraft:chest' do
        MoveDirection(2)
    end

    if turtle.inspect().name == 'minecraft:chest' do
        while turtle.inspect().name == 'minecraft:chest' and not InventoryEmpty() do
            if DepositInventory() then
                
            end
        end
    end
end

function DepositInventory() 
    for i=1, 16, 1 do
        turtle.select(i)
        if not turtle.refuel(0) and not turtle.drop() then
            return false
        end
    end

    return true
end

function InventoryEmpty() 
    for i=1, 16, 1 do
        if not turtle.refuel(0) and turtle.getItemCount(i) >= 0 then
            return false
        end
    end

    return true
end
function InventoryFull() 
    for i=1, 16, 1 do
        if turtle.getItemCount(i) == 0 then
            return false
        end
    end

    return true
end

function DigTunnel(length)
    tunnelLength = length

    while true do
        if turtle.getFuelLevel() < 80 then
            if not Refuel() then
                Stop()
            end
        end

        if DigForward() then
            MoveForward()
            DigUp()
        else
            Stop()
        end

        tunnelLength = tunnelLength - 1

        if tunnelLength < 1 then
            Stop()
        end
    end
end

function Stop()
    os.exit()
end



function selectSlotItem(itemName)
    for i = 1, 16, 1 do
        turtle.select(i)
        if turtle.getItemDetail().name == itemName then
            return true
        end
    end
    turtle.select(1);
    return false
end

function MoveForward()
    if turtle.forward() then
        UpdateLocation()
        return true
    end
    return false
end

function DigForward()
    --Attempts to clear in front of turtle and move forward
    --returns false if block can't be cleared in maxDigAttepts
    local digAttemtps = 0

    while turtle.detect() do
        -- Digs multiple times in case of gravel
        turtle.dig()
        os.sleep(digWait)
        digAttemtps = digAttemtps + 1

        if digAttemtps > maxDigAttempts then
            return false
        end
    end
    return true
end

function DigUp()
    --Attempts to clear in front of turtle and move forward
    --returns false if block can't be cleared in maxDigAttepts
    local digAttemtps = 0

    while turtle.detectUp() do
        -- Digs multiple times in case of gravel
        turtle.digUp()
        os.sleep(digWait)
        digAttemtps = digAttemtps + 1

        if digAttemtps > maxDigAttempts then
            return false
        end
    end
    return true
end


function MoveDirection(dir)
    Turn(dir)
    return MoveForward()
end

function DigDirection(dir)
    Turn(dir)
    return DigForward()
end


DigTunnel(args[1])