--[[
    GD50
    Match-3 Remake

    -- PlayState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    State in which we can actually play, moving around a grid cursor that
    can swap two tiles; when two tiles make a legal swap (a swap that results
    in a valid match), perform the swap and destroy all matched tiles, adding
    their values to the player's point score. The player can continue playing
    until they exceed the number of points needed to get to the next level
    or until the time runs out, at which point they are brought back to the
    main menu or the score entry menu if they made the top 10.
]]

PlayState = Class{__includes = BaseState}

function PlayState:init()
    
    -- start our transition alpha at full, so we fade in
    self.transitionAlpha = 1

    -- position in the grid which we're highlighting
    self.boardHighlightX = 0
    self.boardHighlightY = 0

    -- timer used to switch the highlight rect's color
    self.rectHighlighted = false

    -- flag to show whether we're able to process input (not swapping or clearing)
    self.canInput = true

    self.whiteWon = false
    self.blackWon = false


    -- tile we're currently highlighting (preparing to swap)
    self.highlightedTile = nil

    self.score = 0
    self.timer = 1

    self.notReally = 'white'

    self.bullet = Ball(0, 0, 8, 8)

    -- set our Timer class to turn cursor highlight on and off
    Timer.every(0.5, function()
        self.rectHighlighted = not self.rectHighlighted
    end)

    -- subtract 1 from timer every second
    Timer.every(1, function()
        self.timer = self.timer + 1

        -- play warning sound on timer if we get low
        if self.timer <= 1 then
            gSounds['clock']:play()
        end
    end)
end

function PlayState:enter(params)
    
    -- grab level # from the params we're passed
    self.level = params.level

    -- spawn a board and place it toward the right
    self.board = params.board or Board(VIRTUAL_WIDTH - 272, 16)

    -- grab score from params if it was passed
    self.score = 'no one'

    -- score we have to reach to get to the next level
    self.scoreGoal = self.level * 1.25 * 1000
end

function PlayState:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    -- go back to start if time runs out
    if self.timer <= 0 then
        
        -- clear timers from prior PlayStates
        Timer.clear()
        
        gSounds['game-over']:play()

        gStateMachine:change('game-over', {
            score = self.score
        })
    end

    -- go to next level if we surpass score goal
    if self.whiteWon == true then
        
        -- clear timers from prior PlayStates
        -- always clear before you change state, else next state's timers
        -- will also clear!
        Timer.clear()

        gSounds['next-level']:play()

        -- change to begin game state with new level (incremented)
        gStateMachine:change('begin-game', {
            level = self.level + 1,
            score = self.score
        })
    elseif self.blackWon == true then
                -- clear timers from prior PlayStates
        -- always clear before you change state, else next state's timers
        -- will also clear!
        Timer.clear()

        gSounds['next-level']:play()

        -- change to begin game state with new level (incremented)
        gStateMachine:change('begin-game', {
            level = self.level + 1,
            score = self.score
        })
    end


    if self.canInput then
        -- move cursor around based on bounds of grid, playing sounds
        if love.keyboard.wasPressed('up') then
            self.boardHighlightY = math.max(0, self.boardHighlightY - 1)
            gSounds['select']:play()
        elseif love.keyboard.wasPressed('down') then
            self.boardHighlightY = math.min(7, self.boardHighlightY + 1)
            gSounds['select']:play()
        elseif love.keyboard.wasPressed('left') then
            self.boardHighlightX = math.max(0, self.boardHighlightX - 1)
            gSounds['select']:play()
        elseif love.keyboard.wasPressed('right') then
            self.boardHighlightX = math.min(7, self.boardHighlightX + 1)
            gSounds['select']:play()
        end

        -- if we've pressed enter, to select or deselect a tile...
        if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
            
            -- if same tile as currently highlighted, deselect
            local x = self.boardHighlightX + 1
            local y = self.boardHighlightY + 1
            
            -- if nothing is highlighted, highlight current tile
            if not self.highlightedTile then
                self.highlightedTile = self.board.tiles[y][x]

            -- if we select the position already highlighted, remove highlight
            elseif self.highlightedTile == self.board.tiles[y][x] then
                self.highlightedTile = nil

            -- if the difference between X and Y combined of this highlighted tile
            -- vs the previous is not equal to 1, also remove highlight
            else
                self.numberCalculated = 1
                self:swapper(self.highlightedTile, self.board.tiles[y][x])
                self.numberCalculated = 1
            end

        end
    end

    Timer.update(dt)
end



function PlayState:calculateMoves(piece)
    local Allmoves = self.board:calculateMoves(piece)
    return Allmoves
end



function PlayState:swapper(swapper1, swapper2)
    if swapper1.color == self.notReally then
        local Allmoves = self:calculateMoves(swapper1)

        if Allmoves then
            for k, move in pairs(Allmoves) do
                if move == swapper2 then
                    if swapper2.color == 'no' then

                        swapper1.firstMove = false

                        local tempX = swapper1.gridX
                        local tempY = swapper1.gridY

                        swapper1.gridX = swapper2.gridX
                        swapper1.gridY = swapper2.gridY
                        swapper2.gridX = tempX
                        swapper2.gridY = tempY

                        -- tween coordinates between the two so they swap
                        Timer.tween(0.15, {
                            [swapper1] = {x = swapper2.x, y = swapper2.y},
                            [swapper2] = {x = swapper1.x, y = swapper1.y}
                        })

                        -- once the swap is finished, we can tween falling blocks as needed
                        :finish(function()
                        end)

                        -- swap tiles in the tiles table
                        self.board.tiles[swapper1.gridY][swapper1.gridX] =
                            swapper1

                        self.board.tiles[swapper2.gridY][swapper2.gridX] = 
                            swapper2

                        self.highlightedTile = nil

                        if self.notReally == 'white' then
                            self.notReally = 'black'
                        else
                            self.notReally = 'white'
                        end

                        do return end


                    else
                        swapper1.firstMove = false

                        self.bullet.x = swapper1.x + self.board.x + 12
                        self.bullet.y = swapper1.y + self.board.y + 12
                        self.bullet.visible = true

                        gSounds['pew-pew']:play()

                        Timer.tween(0.2, {
                            [self.bullet] = {x = swapper2.x + self.board.x + 12, y = swapper2.y + self.board.y + 12}
                        })

                        
                        :finish(function()

                            if swapper2.color == 'white' and swapper2.variety == 5 then
                                self.blackWon = true
                            end

                            if swapper2.color == 'black' and swapper2.variety == 5 then
                                self.whiteWon = true
                            end

                            swapper2.health = swapper2.health - 1
                            swapper2.opacity = swapper2.opacity - 1 


                            
                            swapper2.variety = 2
                            swapper2.color = 'no'


                            self.bullet.visible = false
                            self.highlightedTile = nil

                            gSounds['hit-piece']:play()
                            swapper1.firstMove = false

                            local tempX = swapper1.gridX
                            local tempY = swapper1.gridY

                            swapper1.gridX = swapper2.gridX
                            swapper1.gridY = swapper2.gridY
                            swapper2.gridX = tempX
                            swapper2.gridY = tempY

                            -- tween coordinates between the two so they swap
                            Timer.tween(0.15, {
                                [swapper1] = {x = swapper2.x, y = swapper2.y},
                                [swapper2] = {x = swapper1.x, y = swapper1.y}
                            })
                            -- once the swap is finished, we can tween falling blocks as needed
                            :finish(function()
                            end)

                            -- swap tiles in the tiles table
                            self.board.tiles[swapper1.gridY][swapper1.gridX] =
                                swapper1

                            self.board.tiles[swapper2.gridY][swapper2.gridX] = 
                                swapper2

                        end)


                        if self.notReally == 'white' then
                            self.notReally = 'black'
                        else
                            self.notReally = 'white'
                        end

                        do return end

                    end

                end
            end

            gSounds['error']:play()
            self.highlightedTile = nil

            do return end
        
                
        end
    end

    gSounds['error']:play()
    self.highlightedTile = nil
end




function PlayState:render()
    -- render board of tiles
    self.board:render()
    self.bullet:render()

    -- render highlighted tile if it exists
    if self.highlightedTile then
        
        -- multiply so drawing white rect makes it brighter
        love.graphics.setBlendMode('add')

        love.graphics.setColor(1, 1, 1, 96/255)
        love.graphics.rectangle('fill', (self.highlightedTile.gridX - 1) * 32 + (VIRTUAL_WIDTH - 272),
            (self.highlightedTile.gridY - 1) * 32 + 16, 32, 32, 4)

        -- back to alpha
        love.graphics.setBlendMode('alpha')
    end

    -- render highlight rect color based on timer
    if self.rectHighlighted then
        love.graphics.setColor(217/255, 87/255, 99/255, 1)
    else
        love.graphics.setColor(172/255, 50/255, 50/255, 1)
    end

    -- draw actual cursor rect
    love.graphics.setLineWidth(4)
    love.graphics.rectangle('line', self.boardHighlightX * 32 + (VIRTUAL_WIDTH - 272),
        self.boardHighlightY * 32 + 16, 32, 32, 4)

    -- GUI text
    love.graphics.setColor(56/255, 56/255, 56/255, 234/255)
    love.graphics.rectangle('fill', 16, 16, 186, 116, 4)

    love.graphics.setColor(99/255, 155/255, 1, 1)
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Level: ' .. tostring(self.level), 20, 24, 182, 'center')
    love.graphics.printf('Who won : ' .. self.score, 20, 52, 182, 'center')
    love.graphics.printf('Goal : shoot opponent king', 20, 70, 182, 'center')
    love.graphics.printf('Timer: ' .. tostring(self.timer), 20, 108, 182, 'center')
end