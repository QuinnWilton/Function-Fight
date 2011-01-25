--Controls scaling between the screen and the graph
require "middleclass"

Grid = class("Grid")
function Grid:initialize(minX, maxX, minY, maxY, lineInterval)
	self.minX = minX
	self.maxX = maxX
	self.minY = minY
	self.maxY = maxY
	self.lineInterval = lineInterval --Interval between grid lines
end

function Grid:draw()
	self:drawGridLines()
end

function Grid:drawGridLines()
	love.graphics.setColor(unpack(color["text"]))
	--X axis
	horizStart = self:toScreenCoordinates(self.minX, 0)
	horizEnd = self:toScreenCoordinates(self.maxX, 0)
	love.graphics.line(horizStart[1], horizStart[2], horizEnd[1], horizEnd[2])
	love.graphics.print(self.minX, horizStart[1], horizStart[2])
	love.graphics.print(self.maxX, horizEnd[1] - love.graphics.getFont():getWidth(self.maxX), horizStart[2])

	--Y axis
	vertStart = self:toScreenCoordinates(0, self.minY)
	vertEnd = self:toScreenCoordinates(0, self.maxY)
	love.graphics.line(vertStart[1], vertStart[2], vertEnd[1], vertEnd[2])
	love.graphics.print(self.maxY, vertStart[1] + 1, vertStart[2])
	love.graphics.print(self.minY, vertEnd[1] + 1, vertEnd[2] - love.graphics.getFont():getHeight())
	
	--Major gridlines from 0 to maxX
	for i = 0, self.maxX, self.lineInterval do
		lineStart = self:toScreenCoordinates(i, self.minY)
		lineEnd = self:toScreenCoordinates(i, self.maxY)
		love.graphics.line(lineStart[1], lineStart[2], lineEnd[1], lineEnd[2])
	end
	
	--Major gridlines from minX to 0
	for i = 0, self.minX, -self.lineInterval do
		lineStart = self:toScreenCoordinates(i, self.minY)
		lineEnd = self:toScreenCoordinates(i, self.maxY)
		love.graphics.line(lineStart[1], lineStart[2], lineEnd[1], lineEnd[2])
	end
	
	--Major gridlines from 0 to maxY
	for i = 0, self.maxY, self.lineInterval do
		lineStart = self:toScreenCoordinates(self.minX, i)
		lineEnd = self:toScreenCoordinates(self.maxX, i)
		love.graphics.line(lineStart[1], lineStart[2], lineEnd[1], lineEnd[2])
	end
	
	--Major gridlines from minY to 0
	for i = 0, self.minY, -self.lineInterval do
		lineStart = self:toScreenCoordinates(self.minX, i)
		lineEnd = self:toScreenCoordinates(self.maxX, i)
		love.graphics.line(lineStart[1], lineStart[2], lineEnd[1], lineEnd[2])
	end
end

function Grid:drawLabels()
	
end

function Grid:toGridCoordinates(x, y) --Converts a screen position to a position on the grid
	local newX = self.minX + x / love.graphics.getWidth() * (self.maxX - self.minX)
	local newY = self.minY + y / love.graphics.getHeight() * (self.maxY - self.minY)
	return {newX, newY}
end

function Grid:toScreenCoordinates(x, y) --Converts a position on the grid to a screen position
	local newX = (x - self.minX) / (self.maxX - self.minX) * (love.graphics.getWidth())
	local newY = (y - self.minY) / (self.maxY - self.minY) * (love.graphics.getHeight())
	return {newX, newY}
end