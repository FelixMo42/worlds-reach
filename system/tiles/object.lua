local object = class:new({
	type = "object", name = "def",
	color = color.brown,
	walkable = false, moveCost = 1,
	width = 1, height = 1,
	sprites = {}
})

--functions

function object:__tostring()
	return system.tiles:tostring( self , {
		tile = function() return "" end
	} )
end

function object:draw(x,y,s)
	love.graphics.setColor(self.color)
	local sprite = self:getSprite()
	if sprite then
		sprite(x - s * (self.width - 1),y - s * (self.height - 1),s * self.width,s * self.height)
	else
		love.graphics.rectangle("fill",x - s * (self.width - 1),y - s * (self.height - 1),s * self.width,s * self.height)
	end
end

function object:getSprite()
	local p = ""
	for y = -1, 1 do
		for x = -1, 1 do
			if not (self.tile.map[self.tile.x + x] and self.tile.map[self.tile.x + x][self.tile.y + y]) then
				p = p.."-"
			elseif self.tile.map[self.tile.x + x][self.tile.y + y].object then
				local t = self.tile.map[self.tile.x + x][self.tile.y + y].object.type == self.type
				if t then
					p = p.."+"
				else
					p = p.."-"
				end
			else
				p = p.."-"
			end
		end
	end
	for s , sprite in pairs(self.sprites) do
		s = s:gsub(" ",""):gsub("*","."):gsub("%-","%%%-"):gsub("%+","%%%+")
		if string.match(p,s) then
			return sprite
		end
	end
	return self.sprite
end

--load

system.tiles.objects = {}

return object