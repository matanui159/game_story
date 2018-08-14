Object = require("classic")

local Font = require("Font")
local Button = require("Button")

local buttons
local selected
local circle
local cx
local cy

function love.load()
	buttons = {
		Button("This is a button", Font(50, 2, 0.2), 100),
		Button("This is also a button", Font(50, 2, 0.2), 200),
		Button("This is another button", Font(50, 2, 0.2), 300),
	}

end

function love.mousepressed()
	for i, v in ipairs(buttons) do
		if v:hover() then
			selected = v
			circle = 0
			cx = love.mouse.getX()
			cy = love.mouse.getY()
		end
	end
end

function love.update(dt)
	for i, v in ipairs(buttons) do
		v:update(dt)
	end

	if selected then
		circle = circle + dt * 2
		if circle > 2 then
			circle = 2
		end
	end
end

function love.draw()
	if selected then
		love.graphics.stencil(function()
			love.graphics.ellipse("fill", cx, cy, circle * (2 - circle) * love.graphics.getWidth() / 2)
		end)
		love.graphics.setStencilTest("equal", 0)
	end

	if not selected or circle < 1 then
		for i, v in ipairs(buttons) do
			v:draw()
		end
	end

	if selected then
		love.graphics.setStencilTest("equal", 1)
		selected:draw()
	end
	love.graphics.setStencilTest()
end