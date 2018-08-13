local font = require("font")

function love.load()
	font = font.new(50, 2, 20, 0.2)
end

function love.update(dt)
	font:update(dt)
end

function love.draw()
	font:beginDraw()
	love.graphics.printf("Bittersweet is a weird\nlimbo of a feeling", 0, 100, love.graphics.getWidth(), "center")
	font:endDraw()
end