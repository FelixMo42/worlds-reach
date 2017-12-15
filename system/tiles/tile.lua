local tile = class:new({
	type = "tile", name = "def",
	walkable = true,
	color = {0,255,0},
	moveCost = 1
})

--functions

function tile:__tostring()
	if self.file then
		return "system.tiles.tiles."..self.file..":new()"
	else
		return "system.tiles.tile:new()"
	end
end

function tile:draw(x,y,s)
	--tile
	local s = s or system.settings.tiles.scale
	local x = x or (self.x - self.map.x) * system.settings.tiles.scale
	local y = y or (self.y - self.map.y) * system.settings.tiles.scale
	love.graphics.setColor(self.color)
	love.graphics.rectangle("fill",x,y,s,s)
	if system.settings.tiles.line then
		love.graphics.setColor(color.black)
		love.graphics.rectangle("line",x,y,s,s)
	end
	--object
	if self.object then
		self.object:draw(x,y,s)
	end
	--item
	if self.item then
		self.item:draw(x,y,s)
	end
end

function tile:setPlayer(player)
	self.player = player
	player.tile.player = nil
	player.tile = self
end

--load

system.tiles.tiles = {}

return tile