local Font = require("Font")

local Button = Object:extend()
Button.CLOCK = 0.1

function Button:new(text, font, color, y)
	self.text = text
	self.font = font
	self.color = color
	self.timer = 0
	self.count = 0

	self.width = font.font:getWidth(text)
	self.height = font.font:getHeight()
	self.x = (love.graphics.getWidth() - self.width) / 2
	self.y = (love.graphics.getHeight() - self.height) / 2 + y
end

function Button:hover()
	local mx = love.mouse.getX() - self.x
	local my = love.mouse.getY() - self.y
	return mx > 0 and mx < self.width and my > 0 and my < self.height
end

function Button:update(dt)
	self.timer = self.timer + dt
	if self.timer >= 0.05 then
		self.count = self.count + 1
		while self.text:sub(self.count, self.count) == " " do
			self.count = self.count + 1
		end
		self.timer = 0
	end

	if self:hover() then
		self.font:update(dt)
	end
end

function Button:draw()
	self.font:preDraw()
	love.graphics.setColor(unpack(self.color))
	love.graphics.print(self.text:sub(1, self.count), self.x, self.y)
	self.font:postDraw()
end

return Button