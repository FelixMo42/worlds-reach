local object = class:new({
	type = "object", name = "def",
	color = color.brown,
	walkable = false, moveCost = 1,
	width = 1, height = 1
})

--functions

function object:__tostring()
	return system.tiles:tostring( self , {
		tile = function() return "" end
	} )
end

function object:draw(x,y,s)
	love.graphics.setColor(self.color)
	love.graphics.rectangle("fill",x - s * (self.width - 1),y - s * (self.height - 1),s * self.width,s * self.height)
end

--load

system.tiles.objects = {}

return object