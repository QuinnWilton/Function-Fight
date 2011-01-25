require "middleclass"

inputReplacementTable = {{"1", "!"},{"2", "@"},{"3", "#"},{"4", "$"},{"5", "%"},{"6", "^"},{"7", "&"},{"8", "*"},{"9", "("},{"0", ")"},{"-", "_"},{"=", "+"}} --Replacement table for the input box

GameState = State:subclass("GameState")
function GameState:initialize(playerNames)
	self.grid = Grid:new(-25, 25, -25, 25, 10) --Creates a game with 50 width and height, centered on the origin, and gridlines every 10 units
	self:createPlayers(playerNames)
	self.currentPlayer = 1
	self.sky = graphics["sky"]
	self.playing = true
	self.lastTurn = false
	self.drawingFunction = false
	self.drawingPosition = 0
	self.drawingPosition = "left"
	self.playerXIndex = 1
	self.nextDrawTime = 0
	self.numberKilled = 0
	love.graphics.setFont(12)	
	love.audio.play(music["gameMusic"], 0) --Plays the game music
end

function GameState:createPlayers(playerNames) --Spawns the players, assigning them positions
	self.players = {}
	for i = 1, #playerNames do
		local xPos
		if playerNames[i][2] == "left" then
			xPos = math.random(0, love.graphics.getWidth() / 2)
		elseif playerNames[i][2] == "right" then
			xPos = math.random(love.graphics.getWidth() / 2, love.graphics.getWidth())
		end
		self.players[i] = Character:new(playerNames[i][1], playerNames[i][2], xPos, math.random(0, love.graphics.getHeight()))
	end
end

function GameState:update(dt) --Updates all game elements
	if self.playing then
		self.players[self.currentPlayer].isSelected = true --Activates the current player
		for i, v in ipairs(self.players) do
			v:update(dt) --Updates all players
		end
		local team = self.players[1].team
		self.lastTurn = true
		for i, v in ipairs(self.players) do --Checks if one team is destroyed in order to end the game
			if v.team ~= team then self.lastTurn = false end
		end
	end
	if self.drawingFunction and self.nextDrawTime < love.timer.getMicroTime() then --Updates the current function if enough time was passed
		self.drawingPosition = self.drawingPosition + 25 --Draws 25 units at a time
		self.nextDrawTime = love.timer.getMicroTime() + 0.01 --New function drawing tick every 0.
		if self.drawingPosition * 2 >= #self.players[self.currentPlayer].functionImage --If function is done, stop drawing
			or self.players[self.currentPlayer].functionImage[self.drawingPosition*2] < 0 
			or self.players[self.currentPlayer].functionImage[self.drawingPosition*2] > love.graphics.getHeight() then
			if self.lastTurn then self.playing = false end
			self.drawingFunction = false
			self.players[self.currentPlayer].isSelected = false
			self.currentPlayer = self.currentPlayer % #self.players + 1
		end
	end
end

function GameState:draw()
	love.graphics.setColor(unpack(color["text"]))
	if self.playing then
		love.graphics.draw(self.sky, 0, 0, 0, love.graphics.getWidth() / self.sky:getWidth(), love.graphics.getHeight() / self.sky:getHeight())
		self.grid:draw()
		if self.drawingFunction then
			for i = 1, self.drawingPosition do
				love.graphics.line(self.players[self.currentPlayer].functionImage[2*i-1], self.players[self.currentPlayer].functionImage[2*i], self.players[self.currentPlayer].functionImage[2*i + 1], self.players[self.currentPlayer].functionImage[2*i + 2])
			end
		end
		for i, v in ipairs(self.players) do
			v:draw()
		end
		love.graphics.setColor(255, 255, 255, 128)
		love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), 15)
		love.graphics.setColor(0, 0, 0, 255)
		love.graphics.rectangle("line", 0, 0, love.graphics.getWidth(), 15)
		love.graphics.print(string.sub(self.players[self.currentPlayer].currentExpression, 1, self.players[self.currentPlayer].caretPosition - 1) .. "|" .. string.sub(self.players[self.currentPlayer].currentExpression, self.players[self.currentPlayer].caretPosition), 0, 0)
	else
		love.graphics.print("Team "..self.players[1].team.." has won!", love.graphics.getWidth() / 2 - love.graphics.getFont():getWidth("Team "..self.players[1].team.." has won!") / 2, love.graphics.getHeight() / 2)
	end
end

function GameState:mousepressed(x, y, button)
	print("Mouse button ".. button .." pressed at ".. x .." : ".. y)
end

function GameState:mousereleased(x, y, button)
end

function GameState:keypressed(key, unicode)
	print(key.." pressed")
	if key == "return" then
		local okay, err = pcall(function () self:graphExpression() end)
		if not okay then
			print(err)
			self.players[self.currentPlayer].functionImage = {}
		end
	end
	self:getTextInput(key)
end

function GameState:keyreleased(key, unicode)
end

function GameState:getTextInput(key)
	if love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift") then
		for i, v in pairs(inputReplacementTable) do
			if v[1] == key then
				self.players[self.currentPlayer].currentExpression = string.sub(self.players[self.currentPlayer].currentExpression, 1, self.players[self.currentPlayer].caretPosition - 1) .. v[2] .. string.sub(self.players[self.currentPlayer].currentExpression, self.players[self.currentPlayer].caretPosition)
				self.players[self.currentPlayer].caretPosition = self.players[self.currentPlayer].caretPosition + 1
			end
		end
	elseif string.find("abcdefghijklmnopqrstuvwxyz1234567890-/ ", key) ~= nil then
		self.players[self.currentPlayer].currentExpression = string.sub(self.players[self.currentPlayer].currentExpression, 1, self.players[self.currentPlayer].caretPosition - 1) .. key .. string.sub(self.players[self.currentPlayer].currentExpression, self.players[self.currentPlayer].caretPosition)
		self.players[self.currentPlayer].caretPosition = self.players[self.currentPlayer].caretPosition + 1
	elseif key == "left" then
		if self.players[self.currentPlayer].caretPosition > 1 then
			self.players[self.currentPlayer].caretPosition = self.players[self.currentPlayer].caretPosition - 1
		end
	elseif key == "right" then
		if self.players[self.currentPlayer].caretPosition < string.len(self.players[self.currentPlayer].currentExpression) + 1 then
			self.players[self.currentPlayer].caretPosition = self.players[self.currentPlayer].caretPosition + 1
		end
	end
	if love.keyboard.isDown("backspace") then
		if self.players[self.currentPlayer].caretPosition > 1 then
			self.players[self.currentPlayer].currentExpression = string.sub(self.players[self.currentPlayer].currentExpression, 1, self.players[self.currentPlayer].caretPosition - 2) .. string.sub(self.players[self.currentPlayer].currentExpression, self.players[self.currentPlayer].caretPosition)
			self.players[self.currentPlayer].caretPosition = self.players[self.currentPlayer].caretPosition - 1
		end
	end
end

function GameState:graphExpression()
	local expression = Expression:new("-1*("..self.players[self.currentPlayer].currentExpression ..")")
	expression:transform(unpack(self.grid:toGridCoordinates(self.players[self.currentPlayer].xPosition, self.players[self.currentPlayer].yPosition)))
	self.players[self.currentPlayer].functionImage = {}
	love.audio.play(sounds["tauntSounds"][math.random(1, #sounds["tauntSounds"])], 0)
	self.numberKilled = 0
	local start, stop step = 0, 0, 0
	if self.players[self.currentPlayer].team == "left" then
		self.drawingDirection = "left"
		start = self.grid:toGridCoordinates(self.players[self.currentPlayer].xPosition, 0)[1]
		stop = self.grid.maxX
		step = 0.01
	else
		self.drawingDirection = "right"
		start = self.grid:toGridCoordinates(self.players[self.currentPlayer].xPosition, 0)[1]
		stop = self.grid.minX
		step = -0.01
	end
	for i = start, stop, step do
		local x, y = self.grid:toScreenCoordinates(i, 0)[1], self.grid:toScreenCoordinates(0, expression:evaluate(i))[2]
		if y > love.graphics.getHeight() or y < 0 then break end
		for i, v in ipairs(self.players) do
			if v ~= self.players[self.currentPlayer] then
				if x >= v.xPosition - v.image:getWidth() / 2 and x <= v.xPosition + v.image:getWidth() / 2 and y >= v.yPosition - v.image:getHeight() / 2 and y <= v.yPosition + v.image:getHeight() / 2 then
					if i < self.currentPlayer then self.currentPlayer = self.currentPlayer - 1 end
					self.numberKilled = self.numberKilled + 1
					table.remove(self.players, i)
					love.audio.play(sounds["deathSounds"][math.random(1, #sounds["deathSounds"])])
				end	
			end
		end
		table.insert(self.players[self.currentPlayer].functionImage, x)
		table.insert(self.players[self.currentPlayer].functionImage, y)
	end
	self.drawingFunction = true
	self.nextDrawTime = love.timer.getMicroTime()
	self.drawingPosition = 1
end