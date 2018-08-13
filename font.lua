local Font = Object:extend()

function Font:new(size, offset, clock)
	self.font = love.graphics.newFont("assets/IndieFlower.ttf", size)
	self.shader = love.graphics.newShader([[
		varying float random;

		#ifdef VERTEX
			extern float seed;
			extern float offset;

			vec4 position(mat4 matrix, vec4 vertex) {
				random = fract(sin(dot(vertex.xy, vec2(12.3, 45.6)) + seed) * 78910.11);
				float angle = random * 6.2832;
				return matrix * (vertex + vec4(cos(angle), sin(angle), 0.0, 0.0) * offset);
			}
		#endif

		#ifdef PIXEL
			extern vec4 color1;
			extern vec4 color2;

			vec4 effect(vec4 color, Image image, vec2 coord, vec2 pos) {
				return Texel(image, coord) * mix(color1, color2, random);
			}
		#endif
	]])
	self.shader:send("offset", offset)
	self.shader:send("color1", {1, 1, 1, 0.5})
	self.shader:send("color2", {1, 1, 1, 1})
	self.clock = clock
	self.timer = clock
	return obj
end

function Font:update(dt)
	self.timer = self.timer + dt
	if self.timer >= self.clock then
		self.shader:send("seed", math.random())
		if self.clock == 0 then
			self.timer = 0
		else
			self.timer = self.timer % self.clock
		end
	end
end

function Font:preDraw()
	love.graphics.setFont(self.font)
	love.graphics.setShader(self.shader)
end

function Font:postDraw()
	love.graphics.setShader()
end

return Font