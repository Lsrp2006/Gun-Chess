--[[
    GD50 2018
    Pong Remake

    -- Ball Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents a ball which will bounce back and forth between paddles
    and walls until it passes a left or right boundary of the screen,
    scoring a point for the opponent.
]]

Ball = Class{}

function Ball:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    -- these variables are for keeping track of our velocity on both the
    -- X and Y axis, since the ball can move in two dimensions
    self.dy = 0
    self.dx = 0

    self.visible = false
end

function Ball:update(dt)
    self.x = self.x 
    self.y = self.y 
end


function Ball:render()
    if self.visible == true then
        love.graphics.setColor(1, 0.67, 0, 1)
        love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
    else
        love.graphics.setColor(0, 0, 0, 0)
        love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
    end
end