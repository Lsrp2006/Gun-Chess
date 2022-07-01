
CHESS BUT WITH GUNS

the game I created here is what I call chess but with guns. The idea of the game is to shoot the opponent king. Pieces move in the same manner as they do in normal chess, but instead of taking a piece and moving to its space, you shoot the opponent piece and dont move. I created this game by using the match 3 game as a base for the code, and heavily modifying it to create a brand new game. I believe this game meets the complexity requirement because most of the logic for the gameplay was not included originnaly (see examples:) and I think that this game is just as complex. 

examples: creating the black and white squares, piece movement, shooting pieces, etcetera. 

I also think that it meets the distinctiviness requirement since the game is very different from the original base game. It is also an original video game idea that I dont think anyone has done before, and is vastly different from any other video games that we have programmed in this course. 

The game also meets all requirements for final projects. Its a start to finish experience for the user, and it has at least three gameStates.

For these reasons I believe that my submission is complex, distinct, and meets all the requirements for a final project. 



Documentation Of What I Did. 

	So when starting out the project i first tried brainstoriming ideas of something that would original, reasonably complex, and that it would immediatly grab the attention of those who heard of it. What met all these criteria was what I would like to call Chess But With Guns. An idea that when I asked my parents, and friends if they thought was a good idea for a video game, they all had a chuckle and told me to "do it". 

	First comes how I could create a board for the chess pieces to be on. When looking back through the previous games to see how I could implement it I came across match3, and i noticed it had the exact board size needed to play chess on. I decided to use the match3 code as base in which I would heavily modify it to create a chess game on it. The chess board code is divided into two parts, one which cretes the board for the title screen, the other which creates the board for the actual gameplay. 

	For the title screen board I modified the loop the render loop and the position storing loop for the tiles so I could could render both the chess pieces and the black and white tiles. First along with the positions table I created another table that would store the color of the chess pieces. Then a loop that does two things, randomize which type of piece goes on which type of square while storing it on the positions table, and randomize the color of the pieces into black or white and store those values in a ChessPiecesColorsTable. Next in the render function there is a loop which checks every single place on the board. To create the black and white tiles in which the pieces stand on, I created the simple idea of just alternating the two colors starting with white, and if the X position == 8 then don't alternate. After that you use the privious two tables that I mentioned to render the pieces on top of the squares with both their type and color. 

	Next for the gameplay board itself it was simple, first i did the alternating black and white titles idea discussed earlier, then a loop with a bunch of if statments whose logic goes something like this. 

	if y == 1 or 8 then  
		if the x == placesWhichAPieceShouldStartOn then 
			you place the piece
	if y == 2 or 8 then
		place pons 
	else
		place special nothing pon
	end

	The Special Nothing Pon is basically a pon that does not show up and has no affiliation with either side. These basically mark nil places on the board while allowing for pieces to swap places with them. This whole gameplay initialization allowed to store everything's position, color, and type while creating the stating position. 

	for the gameplay itself the main part of it was enabling the pieces to be swapped with each other and how to calculate the moves of every piece. To do this I heavily modifyied my previously created swapper function and created a calculate moves function that uses the piece selected and calls on a calculate moves function on the board class for that specific kind of piece. 

	Pon

		for the pon the logic is quite simple, 

		if Y != 8 and Y != 1 then
		    if color == black then
		        insert (y + 1, x)

		        if firstmove == true then
		            Insert (Y + 2, x)
		        end

		        if x > 1 then
		            if (Y + 1, X - 1).color ~= 'no' then
		                insert(Y - 1, X - 1)
		            end
		        end

		        if x < 8 then
		            if (y + 1, x + 1).color ~= 'no' then
		                insert(Y + 1, X + 1)
		            end
		        end
		    end
		end

		For the pon the color of the piece is important since it can only move forward and what is forward is determined by its color. The above code if its white all mentions of y become 
		(Y - number). Basically the logic for pon is simple, if the y is neither the max nor the minumun of the board, you store the square ahead. Then you check to see if the the pon is on its first move, if yes store the second square ahead of it. After this you check to see if the pon is on the X min or max, if on min dont check left diagonal, if on max dont check right diagonal. when checking one of the diagonals check to see if its not a Special Nothing Pon, if its not store the value. 


	Kinght 

		knight is similar to the pon except the moves dont change if its either of the two colors. 

		if Y <= 6 then
		    if X > 1 then
		        insert (Y + 2, X - 1)
		    end


		    if X < 8 then
		        insert (Y + 2, X + 1)
		    end
		end

		if Y > 2 then
		    if X > 1 then
		        insert (Y - 2, X - 1)
		    end


		    if X < 8 then
		        insert (Y - 2, X + 1)
		    end
		end

		if X <= 6 then
		    if Y > 1 then
		        insert (Y - 1, X + 2)
		    end


		    if Y < 8 then
		        insert (Y + 1, X + 2)
		    end
		end

		if X > 2 then
		    if Y > 1 then
		        insert (Y - 1, X - 2)
		    end


		    if Y < 8 then
		        insert (Y + 1, X - 2)
		    end
		end

		basically the way the knight works is that it checks all the moves it can do while not checking certain moves if the position says they would not be allowed. For example if the knight is at Y = 8 then will not store any values in which Y would be above 8. Similar logic is used for every single case in which a knoght move would = nil so as to not store those moves. 


	King 

		king moves are not if statement monsters like the kight and pon moves, instead one can simply use a nested loop to check every single square around the king while an if statement checks to see if the X or Y values are above or below the max Y or X values. 


		for y = 3, 1, -1 do
		    for x = 3, 1, -1 do
		        if Y + (y-2) >= 1 and Y + (y-2) <= 8 and X + (x-2) >= 1 and X + (x-2) <= 8 then
		            insert(Y + (y-2), X + (x-2))
		        end
		    end
		end



	Rook

		rook moves are where the logic for pieces starts to get very interesting. For rooks to move you have to make it so the moves stop being included if it hits another piece, or if it goes over an edge. You also have to check all four directions. 

		for y = Y - 1, 1, -1 do
		    if (y, X).color == 'no' then
		        insert(y, X)
		    else
		        insert(y, X)
		        break
		    end
		end

		for y = Y + 1, 8 do
		    if (y, X).color == 'no' then
		        insert(y, X)
		    else
		        insert(y, X)
		        break
		    end
		end

		for x = X - 1, 1, -1 do
		    if (Y, x).color == 'no' then
		        insert(Y, x)
		    else
		        insert(Y, x)
		        break
		    end
		end

		for x = X + 1, 8 do
		    if (Y, x).color == 'no' then
		        insert(Y, x)
		    else
		        insert(Y, x)
		        break
		    end
		end

		Basically what you can do is create for loops for each direct that change how many times they runs depending on the X or Y positions of the rook. For example if you want to check downwards and your rook starts at Y = 5, you take 5 - 1 and put it in the for a loop that decreases the value by 1 until it reasches 1, so in it would run 4 times. Similar logic is how the other loops stop before the edge. A loop also automatically stops if a piece is detected while running it. 


	Bishop

		The bishop is similar to the rook but with a but more complicated math. Basically instead of determining how long a loop runs by comparing only the X or Y to the min or max, the bishop has to compare both X and Y to the min and max at once and determine whoch value has less of a difference. 


		For this one I could not find my pseudocode so im putting in the actual code. In turn for this ill explain each loop seperately. 

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


		for the first loop it which one is less between the pieces X and Y values, it then runs the loop for that - 1 number of times. this first loop goes up and left. 

		the second loop goes up and right. Because now we are checking to see if the distance between X and 8 are less then Y we now take the absolute value of (8 - X), this allows us to check to continue using for loops to check the positions. 

		the third loop is similar to the second loop but it runs checking the the absolute value of (8 - Y) instead of X. it goes down and left. 

		the fourth and final loop goes down and right and it takes both of the absolute value of (8 - X) and (8 - Y) to complete the loop. 

		The enumarator variable is basically a variable created so to store how many times the loop has ran, it then uses that information to store what squares are possible for the bishop to move by subtracting or adding the value to both the X and Y of the bishop.

	Queen
		The queen was the easiest piece to make since it was just a combination of the code from the rook and the bishop.

	The swapping and attacking. 

		basically after running the calculate moves function which I talked in detail above, the swapper runs a loop that checks to see if the move that you made is inside the Allmoves table. If the move goes to a Special Nothing Pon then you swap the values of the both squares so the piece goes there. To simulate the movement you can tween the coordinates of the two. If there is a piece there then you create a bullet that tweens from the attacker's to the defender's coordinates, after the tween you have the defender = Special Nothing Pon. If the piece being attacked is the king then the attacker wins. 

	Health System 
		basically each piece has three health, and their health is represented by the opacity of the piece. If the health is lowered to zero the piece becomes a special nothing pon. The opacity is chosen by just getting the value of health/3. 


	The final thing I did was some final quality of life stuff

		The final things I worked on was some of the quality of life stuff. Having text match the theme of my game, modifying the title screen, simple system of if statments to keep track of players turns, a health system, etcetra












