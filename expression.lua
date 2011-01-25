require "middleclass"

replacementTable = {{"(-x)", function(x) i = string.find(x, "-"); return string.sub(x, 1, i) .. "1*x" end},
					{"(%dx)", function(x) i = string.find(x, "%d"); return string.sub(x, 1, i) .. "*x" end},
					{"abs%(", "math.abs%("},
					{"acos%(", "math.acos%("},
					{"asin%(", "math.asin%("},
					{"atan%(", "math.atan%("},
					{"cosh%(", "math.cosh%("},
					{"exp%(", "math.exp%("},
					{"log%(", "math.log%("},
					{"log10%(", "math.log10%("},
					{"pi", "math.pi"},
					{"sinh%(", "math.sinh%("},
					{"sqrt%(", "math.sqrt%("},
					{"tanh%(", "math.tanh%("},
					{"sin%(", "math.sin%("},
					{"cos%(", "math.cos%("},
					{"tan%(", "math.tan%("},
					{"%)%(", "%)*%("}}

Expression = class("Expression")
function Expression:initialize(expression)
	self.expression = expression
	self:parse()
end

function Expression:parse()
	for _, v in ipairs(replacementTable) do
		self.expression = string.gsub(self.expression, v[1], v[2])
	end
	print(self.expression)
end

function Expression:evaluate(value)
	return loadstring("return ".. string.gsub(self.expression, "([^%a]x[^%a])", function(x) i = string.find(x, "x"); return string.sub(x, 1, i -1) .. value .. string.sub(x, i + 1) end))()
end

function Expression:transform(x, y)
	local result = self:evaluate(x)
	local difference = y - result
	self.expression = self.expression .." + "..difference
end