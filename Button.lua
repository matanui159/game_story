local Font = require("Font")

local Button = Object:extend()

function Button:new()
	self.font = Font()
end

function Button:update()
	self.font:update()
end

function Button:draw()

end