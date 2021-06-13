local BaseTurtle = require('base_turtle')

LumberJack = BaseTurtle:new{locations={}}


function LumberJack:start()
    --Make sure it starts 1 up from the ground
    if turtle.detectDown() do
        self:moveUp()
    end

    --Move forward until it hits a tree
    while not turtle.detect() do
        self:moveForward()
    end

    --Start cutting if it hits a tree, otherwise return home
    if turtle.inspect().name == 'minecraft:logs' then
        self:cutLayer()
    else
        self:returnHome()
    end

    self:returnHome()
end

function LumberJack:cutLayer()
    while turtle.inspect().name == 'minecraft:logs' do
        self:digForward()
        self:MoveForward()
        self:digDown()
        self:digUp()
        self:storeLogLocations()
    end
    

end

function LumberJack:storeLogLocations()
    if turtle.inspectLeft().name == 'minecraft:logs' then
        local c = self:getLeftCoordinate()
        self:storeLocation(c.x, c.y)
    end

    if turtle.inspectRight().name == 'minecraft:logs' then
        local c = self:getRightCoordinate()
        self:storeLocation(c.x, c.y)
    end
end


-- Tracking Locations
function LumberJack:storeLocation(x, y) 
    if (self.locations[x]) then
        self.locations[x].insert(y)
    else
        self.locations[x] = {y}
    end
end

function LumberJack:getNextLocations()
    local closest = nil

    for x, ys in self.locations do
        if closest == nil then
            closest = {x=x, y=ys}
        end
        if self.x - x < self.x - closest.x then
            closest = {x=x, ys=ys}
        end
    end

    return closest
end

function LumberJack: ()

end




return LumberJack