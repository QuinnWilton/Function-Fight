--A class meant to act as a framework for states
require "middleclass"

State = class("State")
function State:initialize()
end

function State:update(dt)
end

function State:draw()
end

function State:mousepressed(x, y, button)
	print("Mouse button ".. button .." pressed at ".. x .." : ".. y)
end

function State:mousereleased(x, y, button)
	print("Mouse button ".. button .." pressed at ".. x .." : ".. y)
end

function State:keypressed(key, unicode)
	print(key.." pressed")
end

function State:keyreleased(key, unicode)
	print(key.." pressed")
end