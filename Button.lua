local Font = require("Font")

local Button = Object:extend()
Button.CLOCK = 0.1

function Button:new(text, font, y)
	self.text = text
	self.font = font

	self.width = font.font:getWidth(text)
	self.height = font.font:getHeight()
	self.x = (love.graphics.getWidth() - self.width) / 2
	self.y = y
end

function Button:hover()
	local mx = love.mouse.getX() - self.x
	local my = love.mouse.getY() - self.y
	return mx > 0 and mx < self.width and my > 0 and my < self.height
end

function Button:update(dt)
	if self:hover() then
		self.font:update(dt)
	end
end

function Button:draw()
	self.font:preDraw()
	love.graphics.print(self.text, self.x, self.y)
	self.font:postDraw()
end

return Button