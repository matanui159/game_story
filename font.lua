local font = {}
font.__index = font

function font.new(size, offset, div, clock)
	local obj = setmetatable({
		font = love.graphics.newFont("assets/IndieFlower.ttf", size),
		canvas = love.graphics.newCanvas(),
		shader = love.graphics.newShader([[
			extern Image noise;
			extern vec2 offset;

			vec4 effect(vec4 color, Image image, vec2 coord, vec2 pos) {
				return Texel(image, coord + offset * (Texel(noise, coord).rg * 2.0 + 1.0));
			}
		]]),

		noise = {
			canvas = love.graphics.newCanvas(
				love.graphics.getWidth() / div,
				love.graphics.getHeight() / div
			),
			shader = love.graphics.newShader([[
				extern vec2 offset;

				float random(vec2 pos, float ox, float oy) {
					return fract(sin(dot(pos + vec2(ox, oy), vec2(12.3, 45.6))) * 78910.11);
				}

				vec4 effect(vec4 color, Image image, vec2 coord, vec2 pos) {
					return vec4(random(pos, offset.x, 0.0), random(pos, 0.0, offset.y), 0.0, 1.0);
				}
			]])
		},

		clock = clock,
		timer = clock
	}, font)

	obj.shader:send("noise", obj.noise.canvas)
	obj.shader:send("offset", {
		offset / love.graphics.getWidth(),
		offset / love.graphics.getHeight()
	})
	return obj
end

function font:update(dt)
	self.timer = self.timer + dt
	if self.timer >= self.clock then
		love.graphics.setCanvas(self.noise.canvas)
		love.graphics.setShader(self.noise.shader)
		self.noise.shader:send("offset", {math.random(), math.random()})
		love.graphics.rectangle("fill", 0, 0,
			self.noise.canvas:getWidth(),
			self.noise.canvas:getHeight()
		)
		love.graphics.setShader()
		love.graphics.setCanvas()

		if self.clock == 0 then
			self.timer = 0
		else
			self.timer = self.timer % self.clock
		end
	end
end

function font:beginDraw()
	love.graphics.setCanvas(self.canvas)
	love.graphics.clear()
	love.graphics.setFont(self.font)
end

function font:endDraw()
	love.graphics.setCanvas()
	love.graphics.setShader(self.shader)
	love.graphics.draw(self.canvas)
	love.graphics.setShader()
	-- love.graphics.draw(self.noise.canvas)
end

return font