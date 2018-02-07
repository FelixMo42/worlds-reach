local tile = class:new({
	type = "tile", name = "def",
	walkable = true,
	color = {0,255,0},
	moveCost = 1
})

--functions

function tile:__tostring()
	return system.tiles:tostring( self , {
		object = function(self, k, v)
			if v.tile == self then
				return "object = "..tostring( self.object )
			end
			return ""
		end,
		map = function() return "" end,
		x = function() return "" end,
		y = function() return "" end
	} )
end

function tile:init()
	if self.player then
		self:setPlayer( self.player )
	end
	if self.object then
		self:setObject( self.object )
	end
end

function tile:drawTile(x,y,s)
	local s = s or system.settings.tiles.scale
	local x = x or (self.x - self.map.x) * system.settings.tiles.scale
	local y = y or (self.y - self.map.y) * system.settings.tiles.scale
	--tile
	love.graphics.setColor(self.color)
	if self.sprite then
		self.sprite(x,y,s,s)
	else
		love.graphics.rectangle("fill",x,y,s,s)
	end
	if system.settings.tiles.line then
		love.graphics.setColor(color.black)
		love.graphics.rectangle("line",x,y,s,s)
	end
end

function tile:drawItem(x,y,s)
	local s = s or system.settings.tiles.scale
	local x = x or (self.x - self.map.x) * system.settings.tiles.scale
	local y = y or (self.y - self.map.y) * system.settings.tiles.scale
	--item
	if self.item then
		self.item:draw(x,y,s)
	end
end

function tile:drawPlayer(x,y,s)
	local s = s or system.settings.tiles.scale
	local x = x or (self.x - self.map.x) * system.settings.tiles.scale
	local y = y or (self.y - self.map.y) * system.settings.tiles.scale
	--player
	if self.player then
		self.player:draw()
	end
end

function tile:drawObject(x,y,s)
	local s = s or system.settings.tiles.scale
	local x = x or (self.x - self.map.x) * system.settings.tiles.scale
	local y = y or (self.y - self.map.y) * system.settings.tiles.scale
	--object
	if self.object and self.object.tile == self then
		self.object:draw(x,y,s)
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
	for x = object.width - 1, 0, -1 do
		for y = object.height - 1, 0, -1 do
			self.map[self.x - x][self.y - y]:deletObject()
			self.map[self.x - x][self.y - y].object = object
		end
	end
	self.object.tile = self
end

function tile:deletObject()
	if not self.object or not self.object.tile then return end
	local object = self.object
	for x = 0, object.width - 1 do
		for y = 0, object.height - 1 do
			self.map[object.tile.x - x][object.tile.y - y].object = nil
		end
	end
	object.tile = nil
end

function tile:setItem(item)
	self:deletItem()
	self.item = item
	item.tile = self
end

function tile:deletItem()
	if not self.item then return end
	self.item.tile = nil
	self.item = nil
end

--load

system.tiles.tiles = {}

return tile