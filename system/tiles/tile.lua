local tile = class:new({
	type = "tile", name = "def",
	walkable = true,
	color = {0,255,0},
	moveCost = 1
})

--functions

function tile:__tostring()
	local s = "system.tiles."
	if self.file then
		s = s.."tiles."..self.file..":new({"
	else
		s = s.."tile:new({"
	end
	if self.player then
		s = s.."player = "..tostring( self.player )..", "
	end
	if self.object and self.object.tile == self then
		s = s.."object = "..tostring( self.object )..", "
	end
	return s.."})"
end

function tile:init()
	if self.player then
		self:setPlayer( self.player )
	end
	if self.object then
		self:setObject( self.object )
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
	if self.object and self.object.tile == self then
		self.object:draw(x,y,s)
	end
	--item
	if self.item then
		self.item:draw(x,y,s)
	end
end

function tile:setPlayer(player)
	self.player = player
	if player.tile then
		player.tile.player = nil
	end
	player.tile = self
end

function tile:setObject(object)
	object.tile = self
	for x = 0, object.width - 1 do
		for y = 0, object.height - 1 do
			self.map[self.x + x][self.y + y]:deletObject()
			self.map[self.x + x][self.y + y].object = object
		end
	end
end

function tile:deletObject()
	if not self.object then return end
	local object = self.object
	for x = 0, object.width - 1 do
		for y = 0, object.height - 1 do
			self.map[object.tile.x + x][object.tile.y + y].object = nil
		end
	end
	object.tile = nil
end

--load

system.tiles.tiles = {}

return tile