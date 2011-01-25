--Menu which allows the player to set the number of players per team
OptionMenuState = State:subclass("Menu")
function OptionMenuState:initialize()
	self.buttons = {	teamOne = Button.create("Team 1 Size", love.graphics.getWidth() / 2, 250),
						teamTwo = Button.create("Team 2 Size", love.graphics.getWidth() / 2, 350),
						backToMenu = Button.create("Return to Menu", love.graphics.getWidth() / 2, 450)} --Creates the menu buttons, storing them in a table
	love.graphics.setBackgroundColor(unpack(color["background"]))
	self.nextLine = love.timer.getMicroTime() --Stores the system time to next refresh the background
end

function OptionMenuState:draw()
	for n,b in pairs(self.buttons) do --Iterates over the button table, drawing them
		b:draw()
	end
	self:drawMatrixBackground() --Draws the falling text in the background
	love.graphics.setColor(color["text"])
	love.graphics.draw(graphics["logo"], 0, 150, 0, love.graphics.getWidth() / graphics["logo"]:getWidth(), 1, 0, 0)
	for i = 1, numberOfPlayers[1] do --Draws the number of players on team one
		love.graphics.draw(graphics["characterRight"], love.graphics.getWidth() / 2 - (graphics["characterRight"]:getWidth() * numberOfPlayers[1] / 2) + (i-1) * graphics["characterRight"]:getWidth(), 300 - graphics["characterRight"]:getHeight())
	end
	for i = 1, numberOfPlayers[2] do --Draws the number of players on team two
		love.graphics.draw(graphics["characterLeft"], love.graphics.getWidth() / 2 - (graphics["characterLeft"]:getWidth() * numberOfPlayers[2] / 2) + (i-1) * graphics["characterLeft"]:getWidth(), 400 - graphics["characterLeft"]:getHeight())
	end
end

function OptionMenuState:update(dt)
	print(unpack(numberOfPlayers))
	self:generateMatrixLine(dt) --Refreshes the background with a new line
	for n,b in pairs(self.buttons) do
		b:update(dt) --Checks whether each button is being clicjed
	end
end

function OptionMenuState:mousepressed(x,y,button)
	for n,b in pairs(self.buttons) do
		if b:mousepressed(x,y,button) then
			if n == "teamOne" then
				numberOfPlayers[1] = numberOfPlayers[1] % 8 + 1 --If pressed, increase players on team one by one, to a maximum of 8
			elseif n == "teamTwo" then
				numberOfPlayers[2] = numberOfPlayers[2] % 8 + 1 --If pressed, increase players on team two by one, to a maximum of 8
			elseif n == "backToMenu" then
				state = MainMenuState:new() --If pressed, return to main menu
			end
		end
	end
end

function OptionMenuState:generateMatrixLine(dt)
	if love.timer.getMicroTime() > self.nextLine then --If system time exceeds time of next refresh
		self.nextLine = love.timer.getMicroTime() + 0.05 --Set next refresh to 0.05 seconds later
		line = ""
		for i = 1, math.floor(love.graphics.getWidth() / love.graphics.getFont():getWidth(" ")) do
			if math.random() > 0.9 then --10% chance of adding a character to the current line position
				line = line .. math.floor(math.random(0, 9))
			else --Otherwise add an empty space
				line = line .. " "
			end
		end
		table.insert(screenLines, 1, line) --Insert new line to the table of background linse
	end
end

function OptionMenuState:drawMatrixBackground()
	love.graphics.setFont(12)
	love.graphics.setColor(0, 255, 0)
	for i = 1, #screenLines do --Line of size 12 font is 15 pixels, iterate over each line drawing it at the corresponding y position
		if (i-1)*15 > love.graphics.getHeight() then table.remove(screenLines, i) break end
		love.graphics.print(screenLines[i], 0, (i-1) * 15)
	end
	love.graphics.setColor(unpack(color["background"]))
end