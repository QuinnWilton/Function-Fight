require "middleclass"

Character = class("Character")
function Character:initialize(name, team, xPosition, yPosition)
	self.name = name
	self.xPosition = xPosition
	self.yPosition = yPosition
	self.timeAlive = 0
	self.isSelected = false
	self.isAlive = true
	self.team = team
	self.currentExpression = ""
	self.caretPosition = 1
	self.functionImage = {}
	self.functionColour = {math.random(0, 255),math.random(0, 255),math.random(0, 255)}
	if team == "left" then
		self.image = graphics["characterRight"]
	elseif team == "right" then
		self.image = graphics["characterLeft"]
	end
end

function Character:draw()
	love.graphics.setColor(unpack(color["text"]))
	if self.isAlive then
		love.graphics.draw(self.image, self.xPosition - self.image:getWidth() / 2, self.yPosition - self.image:getHeight() / 2, 0, 1, 1, 0, 0)
		self:drawName()
	else
		love.graphics.setColor(255, 0, 0)
		love.graphics.draw(self.image, self.xPosition - self.image:getWidth() / 2, self.yPosition - self.image:getHeight() / 2, 0, 1, 1, 0, 0)
		love.graphics.setColor(255, 255, 255)
	end
	love.graphics.setColor(unpack(self.functionColour))
	if not self.isSelected then
		love.graphics.line(self.functionImage)
	end
end

function Character:drawName()
	--Add a sinusoidal effect to the name if the player is selected
	local newPosition = self.xPosition - love.graphics.getFont():getWidth(self.name) / 2
	for i = 0, #self.name do
		local c = self.name:sub(i, i)	
		local yPos
		if self.isSelected == true then
			yPos = 3 * math.sin(1.5*(self.timeAlive - i*math.pi/#self.name)) + self.yPosition - self.image:getHeight() / 2 - 15
		else
			yPos = self.yPosition - self.image:getHeight() / 2 - 15
		end
		love.graphics.print(c, newPosition, yPos)
		newPosition = newPosition + love.graphics.getFont():getWidth(c) + 1
	end
end

function Character:update(dt)
	if self.isAlive then
		self.timeAlive = self.timeAlive + dt
	end
end