Object = require("classic")

local Font = require("Font")
local Button = require("Button")
local Story = require("story")

local story
local buttons
local choice
local circle

function love.load()
	story = Story(1)
	buttons = story:resume()
end

function love.mousepressed()
	for i, button in ipairs(buttons) do
		if not circle and button:hover() then
			choice = i
			circle = {
				timer = 0,
				x = love.mouse.getX(),
				y = love.mouse.getY()
			}
		end
	end
end

function love.update(dt)
	for i, button in ipairs(buttons) do
		button:update(dt)
	end

	if circle then
		circle.timer = circle.timer + dt * 2
		if circle.timer > 2 then
			buttons = story:resume(choice)
			circle = nil
		end
	end
end

function love.draw()
	if circle then
		love.graphics.stencil(function()
			local size = 0
			for i, button in ipairs(buttons) do
				if button.width > size then
					size = button.width
				end
			end

			local t = circle.timer
			love.graphics.ellipse("fill", circle.x, circle.y, t * (2 - t) * size)
		end)
		love.graphics.setStencilTest("equal", 0)
	end

	if not circle or circle.timer < 1 then
		for i, button in ipairs(buttons) do
			button:draw()
		end
	end

	if circle and #buttons > 1 then
		love.graphics.setStencilTest("equal", 1)
		buttons[choice]:draw()
	end
	love.graphics.setStencilTest()
end