--[[
    GD50
    Match-3 Remake

    -- Board Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The Board is our arrangement of Tiles with which we must try to find matching
    sets of three horizontally or vertically.
]]

Board = Class{}

function Board:init(x, y, level)
    self.x = x
    self.y = y
    self.level = level
    self.moves = {}
    self.ChessTrueBoard = true

    self:initializeTiles()
end

function Board:initializeTiles()
    self.tiles = {}

    self.pieceColor = 'black'

    for tileY = 1, 8 do
        
        if tileY == 3 then
            self.pieceColor = 'white'
        end
        
        -- empty table that will serve as a new row
        table.insert(self.tiles, {})

        for tileX = 1, 8 do

            if tileY == 1 or tileY == 8 then 
                if tileX == 1 or tileX == 8 then
                    table.insert(self.tiles[tileY], Tile(tileX, tileY, self.pieceColor, 6))
                elseif tileX == 2 or tileX == 7 then
                    table.insert(self.tiles[tileY], Tile(tileX, tileY, self.pieceColor, 1))
                elseif tileX == 3 or tileX == 6 then
                    table.insert(self.tiles[tileY], Tile(tileX, tileY, self.pieceColor, 4))
                elseif tileX ==  5 then
                    table.insert(self.tiles[tileY], Tile(tileX, tileY, self.pieceColor, 3))
                elseif tileX == 4 then
                    table.insert(self.tiles[tileY], Tile(tileX, tileY, self.pieceColor, 5))
                end
            elseif tileY == 2 or tileY == 7 then
                table.insert(self.tiles[tileY], Tile(tileX, tileY, self.pieceColor, 2))
            else
                table.insert(self.tiles[tileY], Tile(tileX, tileY, 'no', 2))
            end



            
        end
    end

end

--[[
    Goes left to right, top to bottom in the board, calculating matches by counting consecutive
    tiles of the same color. Doesn't need to check the last tile in every row or column if the 
    last two haven't been a match.
]]



--[[
    Shifts down all of the tiles that now have spaces below them, then returns a table that
    contains tweening information for these new tiles.
]]

function Board:calculateMoves(piece)
    local Moves = {}

    -- knight moves
    if piece.variety == 1 then
        if piece.gridY <= 6 then
            if piece.gridX > 1 then
                table.insert(Moves, self.tiles[piece.gridY + 2][piece.gridX - 1])
            end


            if piece.gridX < 8 then
                table.insert(Moves, self.tiles[piece.gridY + 2][piece.gridX + 1])
            end
        end

        if piece.gridY > 2 then
            if piece.gridX > 1 then
                table.insert(Moves, self.tiles[piece.gridY - 2][piece.gridX - 1])
            end


            if piece.gridX < 8 then
                table.insert(Moves, self.tiles[piece.gridY - 2][piece.gridX + 1])
            end
        end

        if piece.gridX <= 6 then
            if piece.gridY > 1 then
                table.insert(Moves, self.tiles[piece.gridY - 1][piece.gridX + 2])
            end


            if piece.gridY < 8 then
                table.insert(Moves, self.tiles[piece.gridY + 1][piece.gridX + 2])
            end
        end

        if piece.gridX > 2 then
            if piece.gridY > 1 then
                table.insert(Moves, self.tiles[piece.gridY - 1][piece.gridX - 2])
            end


            if piece.gridY < 8 then
                table.insert(Moves, self.tiles[piece.gridY + 1][piece.gridX - 2])
            end
        end




    -- pon moves
    elseif piece.variety == 2 then
        if piece.gridY ~= 8 and piece.gridY ~= 1 then
            if piece.color == 'black' then
                table.insert(Moves, self.tiles[piece.gridY + 1][piece.gridX])
                if piece.firstMove == true then
                    table.insert(Moves, self.tiles[piece.gridY + 2][piece.gridX])
                end

                if piece.gridX > 1 then
                    if self.tiles[piece.gridY + 1][piece.gridX - 1].color ~= 'no' then
                        table.insert(Moves, self.tiles[piece.gridY + 1][piece.gridX - 1])
                    end
                end

                if piece.gridX < 8 then
                    if self.tiles[piece.gridY + 1][piece.gridX + 1].color ~= 'no' then
                        table.insert(Moves, self.tiles[piece.gridY + 1][piece.gridX + 1])
                    end
                end

            elseif piece.color == 'white' then
                table.insert(Moves, self.tiles[piece.gridY - 1][piece.gridX])
                if piece.firstMove == true then
                    table.insert(Moves, self.tiles[piece.gridY - 2][piece.gridX])
                end

                if piece.gridX > 1 then
                    if self.tiles[piece.gridY - 1][piece.gridX - 1].color ~= 'no' then
                        table.insert(Moves, self.tiles[piece.gridY - 1][piece.gridX - 1])
                    end
                end

                if piece.gridX < 8 then
                    if self.tiles[piece.gridY - 1][piece.gridX + 1].color ~= 'no' then
                        table.insert(Moves, self.tiles[piece.gridY - 1][piece.gridX + 1])
                    end
                end

            end
        end


    -- king moves
    elseif piece.variety == 5 then
        for y = 3, 1, -1 do
            for x = 3, 1, -1 do
                if piece.gridY + (y-2) >= 1 and piece.gridY + (y-2) <= 8 and piece.gridX + (x-2) >= 1 and piece.gridX + (x-2) <= 8 then
                    table.insert(Moves, self.tiles[piece.gridY + (y-2)][piece.gridX + (x-2)])
                end
            end
        end


    -- rock moves
    elseif piece.variety == 6 then
        for y = piece.gridY - 1, 1, -1 do
            if self.tiles[y][piece.gridX].color == 'no' then
                table.insert(Moves, self.tiles[y][piece.gridX])
            else
                table.insert(Moves, self.tiles[y][piece.gridX])
                break
            end
        end

        for y = piece.gridY + 1, 8 do
            if self.tiles[y][piece.gridX].color == 'no' then
                table.insert(Moves, self.tiles[y][piece.gridX])
            else
                table.insert(Moves, self.tiles[y][piece.gridX])
                break
            end
        end

        for x = piece.gridX - 1, 1, -1 do
            if self.tiles[piece.gridY][x].color == 'no' then
                table.insert(Moves, self.tiles[piece.gridY][x])
            else
                table.insert(Moves, self.tiles[piece.gridY][x])
                break
            end
        end

        for x = piece.gridX + 1, 8 do
            if self.tiles[piece.gridY][x].color == 'no' then
                table.insert(Moves, self.tiles[piece.gridY][x])
            else
                table.insert(Moves, self.tiles[piece.gridY][x])
                break
            end
        end

    -- bishop moves
    elseif piece.variety == 4 then
        local enumerator = 0
        for i = math.min(piece.gridY - 1, piece.gridX - 1), 1, -1 do
            enumerator = enumerator + 1
            if self.tiles[piece.gridY - enumerator][piece.gridX - enumerator].color == 'no' then
                table.insert(Moves, self.tiles[piece.gridY - enumerator][piece.gridX - enumerator])
            else
                table.insert(Moves, self.tiles[piece.gridY - enumerator][piece.gridX - enumerator])
                break
            end
        end

        enumerator = 0

        for i = math.min(piece.gridY - 1, math.abs(8 - (piece.gridX ))), 1, -1 do
            enumerator = enumerator + 1
            if self.tiles[piece.gridY - enumerator][piece.gridX + enumerator].color == 'no' then
                table.insert(Moves, self.tiles[piece.gridY - enumerator][piece.gridX + enumerator])
            else
                table.insert(Moves, self.tiles[piece.gridY - enumerator][piece.gridX + enumerator])
                break
            end
        end

        enumerator = 0

        for i = math.min(math.abs(8 - (piece.gridY)), piece.gridX - 1), 1, -1 do
            enumerator = enumerator + 1
            if self.tiles[piece.gridY + enumerator][piece.gridX - enumerator].color == 'no' then
                table.insert(Moves, self.tiles[piece.gridY + enumerator][piece.gridX - enumerator])
            else
                table.insert(Moves, self.tiles[piece.gridY + enumerator][piece.gridX - enumerator])
                break
            end
        end

        enumerator = 0

        for i = math.min(math.abs(8 - (piece.gridY)), math.abs(8 - (piece.gridX ))), 1, -1 do
            enumerator = enumerator + 1
            if self.tiles[piece.gridY + enumerator][piece.gridX + enumerator].color == 'no' then
                table.insert(Moves, self.tiles[piece.gridY + enumerator][piece.gridX + enumerator])
            else
                table.insert(Moves, self.tiles[piece.gridY + enumerator][piece.gridX + enumerator])
                break
            end
        end


    elseif piece.variety == 3 then
        for y = piece.gridY - 1, 1, -1 do
            if self.tiles[y][piece.gridX].color == 'no' then
                table.insert(Moves, self.tiles[y][piece.gridX])
            else
                table.insert(Moves, self.tiles[y][piece.gridX])
                break
            end
        end

        for y = piece.gridY + 1, 8 do
            if self.tiles[y][piece.gridX].color == 'no' then
                table.insert(Moves, self.tiles[y][piece.gridX])
            else
                table.insert(Moves, self.tiles[y][piece.gridX])
                break
            end
        end

        for x = piece.gridX - 1, 1, -1 do
            if self.tiles[piece.gridY][x].color == 'no' then
                table.insert(Moves, self.tiles[piece.gridY][x])
            else
                table.insert(Moves, self.tiles[piece.gridY][x])
                break
            end
        end

        for x = piece.gridX + 1, 8 do
            if self.tiles[piece.gridY][x].color == 'no' then
                table.insert(Moves, self.tiles[piece.gridY][x])
            else
                table.insert(Moves, self.tiles[piece.gridY][x])
                break
            end
        end

        local enumerator = 0
        for i = math.min(piece.gridY - 1, piece.gridX - 1), 1, -1 do
            enumerator = enumerator + 1
            if self.tiles[piece.gridY - enumerator][piece.gridX - enumerator].color == 'no' then
                table.insert(Moves, self.tiles[piece.gridY - enumerator][piece.gridX - enumerator])
            else
                table.insert(Moves, self.tiles[piece.gridY - enumerator][piece.gridX - enumerator])
                break
            end
        end

        enumerator = 0

        for i = math.min(piece.gridY - 1, math.abs(8 - (piece.gridX ))), 1, -1 do
            enumerator = enumerator + 1
            if self.tiles[piece.gridY - enumerator][piece.gridX + enumerator].color == 'no' then
                table.insert(Moves, self.tiles[piece.gridY - enumerator][piece.gridX + enumerator])
            else
                table.insert(Moves, self.tiles[piece.gridY - enumerator][piece.gridX + enumerator])
                break
            end
        end

        enumerator = 0

        for i = math.min(math.abs(8 - (piece.gridY)), piece.gridX - 1), 1, -1 do
            enumerator = enumerator + 1
            if self.tiles[piece.gridY + enumerator][piece.gridX - enumerator].color == 'no' then
                table.insert(Moves, self.tiles[piece.gridY + enumerator][piece.gridX - enumerator])
            else
                table.insert(Moves, self.tiles[piece.gridY + enumerator][piece.gridX - enumerator])
                break
            end
        end

        enumerator = 0

        for i = math.min(math.abs(8 - (piece.gridY)), math.abs(8 - (piece.gridX ))), 1, -1 do
            enumerator = enumerator + 1
            if self.tiles[piece.gridY + enumerator][piece.gridX + enumerator].color == 'no' then
                table.insert(Moves, self.tiles[piece.gridY + enumerator][piece.gridX + enumerator])
            else
                table.insert(Moves, self.tiles[piece.gridY + enumerator][piece.gridX + enumerator])
                break
            end
        end
    end

    return Moves

end


function Board:render()
    self.ChessTrueBoard = true
    for y = 1, #self.tiles do
        for x = 1, #self.tiles[1] do

            if self.tiles[y][x] ~= nil then
                self.tiles[y][x]:render(self.x, self.y, self.ChessTrueBoard)
            end

            if x ~= 8 then
                if self.ChessTrueBoard == true then
                    self.ChessTrueBoard = false
                else
                    self.ChessTrueBoard = true 
                end
            end
        end
    end
end