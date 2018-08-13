Object = require("classic")

local Font = require("Font")
local font

function love.load()
	font = Font(50, 2, 0.2)
end

function love.update()
	font:update()
end

function love.draw()
	font:preDraw()
	love.graphics.printf("This is some text", 0, 100, love.graphics.getWidth(), "center")
	font:postDraw()
end