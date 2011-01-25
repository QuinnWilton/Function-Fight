Button = {}
Button.__index = Button

function Button.create(text,x,y)
	local temp = {}
	setmetatable(temp, Button)
	temp.hover = false
	temp.click = false
	temp.text = text
	temp.width = font["large"]:getWidth(text)
	temp.height = font["large"]:getHeight()
	temp.x = x - (temp.width / 2)
	temp.y = y
	return temp
end

function Button:draw()
	love.graphics.setFont(font["large"])
	if self.hover then love.graphics.setColor(unpack(color["main"]))
	else love.graphics.setColor(unpack(color["text"])) end
	love.graphics.print(self.text, self.x, self.y-self.height)
end

function Button:update(dt)
	self.hover = false
	local x = love.mouse.getX()
	local y = love.mouse.getY()
	if x > self.x
		and x < self.x + self.width
		and y > self.y - self.height
		and y < self.y then
		self.hover = true
	end	
end

function Button:mousepressed(x, y, button)	
	if self.hover then
		if audio then
			love.audio.play(sound["click"])
		end
		return true
	end
	return false	
end