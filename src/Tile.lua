--[[
    GD50
    Match-3 Remake

    -- Tile Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The individual tiles that make up our game board. Each Tile can have a
    color and a variety, with the varietes adding extra points to the matches.
]]

Tile = Class{}

function Tile:init(x, y, color, variety)
    
    -- board positions
    self.gridX = x
    self.gridY = y

    -- coordinate positions
    self.x = (self.gridX - 1) * 32
    self.y = (self.gridY - 1) * 32

    -- tile appearance/points
    self.color = color
    self.variety = variety

    self.firstMove = true


    -- might add a health system later
    self.health = 3
    self.opacity = 3
    self.opacityFraction = 3
    
end

function Tile:render(x, y, bool)


    if bool == true then
        love.graphics.setColor(0.91, 0.77, 0.62, 1)
        love.graphics.rectangle('fill', self.x + x, self.y + y, 32, 32)
    elseif bool == false then
        love.graphics.setColor(0.25, 0.16, 0.23, 1)
        love.graphics.rectangle('fill', self.x + x, self.y + y, 32, 32)
    end

    if self.color == 'black' then
        love.graphics.setColor(1, 1, 1, self.opacity/self.opacityFraction)
        love.graphics.draw(gTextures['black'], gFrames['black'][self.variety], 
            self.x + x, self.y + y)
    elseif self.color == 'white' then
        love.graphics.setColor(1, 1, 1, self.opacity/self.opacityFraction)
        love.graphics.draw(gTextures['white'], gFrames['white'][self.variety], 
            self.x + x, self.y + y)
    else
        love.graphics.setColor(0, 0, 0, 0)
        love.graphics.draw(gTextures['white'], gFrames['white'][self.variety], 
            self.x + x, self.y + y)
    end

    if self.color ~= 'no' then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(gTextures['gun'], gFrames['gun'][self.variety], 
            self.x + x + 16, self.y + y + 16)
    end
    
end

