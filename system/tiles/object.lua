local object = class:new({
	type = "object", name = "def",
	color = color.brown,
	walkable = false
})

--functions

function object:draw(x,y,s)
	love.graphics.setColor(self.color)
	love.graphics.rectangle("fill",x,y,s,s)
end

--load

system.tiles.objects = {}

return object