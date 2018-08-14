local Font = Object:extend()
Font.sizes = {}

function Font:new(size, offset, clock)
	if not Font.shader then
		Font.shader = love.graphics.newShader([[
			extern float seed;
			extern float offset;

			vec4 position(mat4 matrix, vec4 vertex) {
				float random = fract(sin(dot(vertex.xy, vec2(12.3, 45.6)) + seed) * 78910.11);
				float angle = random * 6.2832;
				return matrix * (vertex + vec4(cos(angle), sin(angle), 0.0, 0.0) * offset);
			}
		]])
	end
	if not Font.sizes[size] then
		Font.sizes[size] = love.graphics.newFont("assets/IndieFlower.ttf", size)
	end

	self.font = Font.sizes[size]
	self.offset = offset
	self.clock = clock
	self.timer = clock
	self.seed = 0
end

function Font:update(dt)
	self.timer = self.timer + dt
	if self.timer >= self.clock then
		self.seed = love.math.random()
		self.timer = 0
	end
end

function Font:preDraw()
	love.graphics.setFont(self.font)
	love.graphics.setShader(Font.shader)
	Font.shader:send("seed", self.seed)
	Font.shader:send("offset", self.offset)
end

function Font:postDraw()
	love.graphics.setShader()
end

return Font