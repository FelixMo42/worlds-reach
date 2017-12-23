local object = class:new({
	type = "object", name = "def",
	color = color.brown,
	walkable = false, moveCost = 1,
	width = 1, height = 1
})

--functions

function object:__tostring()
	local s = "system.tiles."
	if self.file then
		s = s.."objects."..self.file..":new({"
	else
		s = s.."object:new({"
	end
	return s.."})"
end

function object:draw(x,y,s)
	love.graphics.setColor(self.color)
	love.graphics.rectangle("fill",x,y,s * self.width,s * self.height)
end

--load

system.tiles.objects = {}

return object