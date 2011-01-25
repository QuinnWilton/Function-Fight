--Menu with buttons to start the game, exit, or edit game options
MainMenuState = State:subclass("Menu")
function MainMenuState:initialize()
	self.buttons = {	new = Button.create("Start Game", love.graphics.getWidth() / 2, 350),
						options = Button.create("Options", love.graphics.getWidth() / 2, 400),
						quit = Button.create("Quit",love.graphics.getWidth() / 2, 450) } --Creates all the buttons and stores them in a  table
	love.graphics.setBackgroundColor(0, 0, 0)
	self.nextLine = love.timer.getMicroTime() --Stores the system time to next refresh the background
	love.audio.play(music["menuIntro"], 0) --Players the intro sound effect
end

function MainMenuState:draw()
	for n,b in pairs(self.buttons) do
		b:draw() --Draws all buttons
	end
	self:drawMatrixBackground() --Draws the background
	love.graphics.setColor(color["text"])
	love.graphics.draw(graphics["logo"], 0, 150, 0, love.graphics.getWidth() / graphics["logo"]:getWidth(), 1, 0, 0) --Draws the game logo
end

function MainMenuState:update(dt)
	self:generateMatrixLine(dt) --Refreshes the background with a new line
	for n,b in pairs(self.buttons) do
		b:update(dt) --Checks whether each button is being clicked
	end
end

function MainMenuState:mousepressed(x,y,button)
	for n,b in pairs(self.buttons) do
		if b:mousepressed(x,y,button) then
			if n == "new" then
				state = GameState:new(self:generatePlayers()) --Start the game if clicked
			elseif n == "options" then
				state = OptionMenuState:new() --Enter the options menu if clicked
			elseif n == "quit" then
				love.event.push("q") --Exit the game if clicked
			end
		end
	end
end

function MainMenuState:generatePlayers() --Assign each player a randomly generated name
	local players = {}
	for i = 1, numberOfPlayers[1] do
		table.insert(players, {"The " .. randomAdjectives[math.random(1, #randomAdjectives)] .. " " .. randomNames[math.random(1, #randomNames)], "left"})
	end
	for i = 1, numberOfPlayers[2] do
		table.insert(players, {"The " .. randomAdjectives[math.random(1, #randomAdjectives)] .. " " .. randomNames[math.random(1, #randomNames)], "right"})
	end
	return players
end

function MainMenuState:generateMatrixLine(dt) --Refresh screen with new line
	if love.timer.getMicroTime() > self.nextLine then
		self.nextLine = love.timer.getMicroTime() + 0.05
		line = ""
		for i = 1, math.floor(love.graphics.getWidth() / love.graphics.getFont():getWidth(" ")) do
			if math.random() > 0.9 then
				line = line .. math.floor(math.random(0, 9))
			else
				line = line .. " "
			end
		end
		table.insert(screenLines, 1, line)
	end
end

function MainMenuState:drawMatrixBackground() --Draw background
	love.graphics.setFont(12)
	love.graphics.setColor(0, 255, 0)
	for i = 1, #screenLines do
		if (i-1)*15 > love.graphics.getHeight() then table.remove(screenLines, i) break end
		love.graphics.print(screenLines[i], 0, (i-1) * 15)
	end
	love.graphics.setColor(unpack(color["background"]))
end