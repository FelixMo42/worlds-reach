local map = class:new({
	type = "map", name = "def",
	width = 100, height = 100,
	players = {}, turn = 1, position = 0,
	x = 1, y = 1,
})

--functions

function map:__init()
	for x = 1 , self.width do
		self[x] = self[x] or {}
		for y = 1 , self.height do
			self[x][y] = self[x][y] or (self.default or system.tiles.tile):new({isDefault = true})
			self:setupTile(x,y)
		end
	end
	if #self.players > 0 then
		self:nextTurn()
	end
end

function map:__tostring()
	return system.tiles:tostring( self )
end

function map:draw()
	local b = 0
	local sx = math.max( math.floor( self.x ) - b , 1)
	local ex = math.min( math.floor( self.x + screen.width / system.settings.tiles.scale ) + b , self.width )
	local sy = math.max( math.floor( self.y ) - b , 1 ) 
	local ey = math.min( math.floor( self.y + screen.height / system.settings.tiles.scale ) + b , self.height )
	--tiles
	for y = sy , ey do
		for x = sx , ex do
			self[x][y]:draw()
		end
	end
	--players
	for y = sy , ey do
		for x = sx , ex do
			if self[x][y].player then
				self[x][y].player:draw()
			end
		end
	end
end

function map:update(dt)
	for i, player in pairs(self.players) do
		player:update(dt)
	end
end

--tile

function map:setTile(t,sx,sy,ex,ey)
	ex , ey = ex or sx , ey or sy
	for x = sx , ex , (math.sign(ex - sx) == 0 and 1 or math.sign(ex - sx)) do
		for y = sy , ey , (math.sign(ey - sy) == 0 and 1 or math.sign(ey - sy)) do
			table.set( self[x][y] , self[x][y]:new( t ) )
		end
	end
end

function map:setDefault(sx,sy,ex,ey)
	local tile = (self.default or system.tiles.tile):new({isDefault = true})
	self:setTile( tile ,sx,sy,ex,ey)
end

function map:setupTile(x,y)
	self[x][y].map = self
	self[x][y].x = x
	self[x][y].y = y
	self[x][y]:init()
end

function map:expand(w,h)
	for x = 1, w do
		self[x] = self[x] or {}
		for y = 1, h do
			if not self[x][y] then
				self[x][y] = (self.default or system.tiles.tile):new({isDefault = true})
				self[x][y].map = self
				self[x][y].x = x
				self[x][y].y = y
				self[x][y]:init()
			end
		end
	end
end

--player

function map:addPlayer(p)
	if self[p.x][p.y].player then return false , self[p.x][p.y].player end
	p.map , p.tile = self , self[p.x][p.y]
	self.players[#self.players + 1] = p
	self[p.x][p.y].player = p
	return true , p
end

function map:removePlayer(p)
	for i , player in pairs( self.players ) do
		if player == p then
			table.remove( self.players , i )
		end
	end
	self[p.x][p.y].player = nil
	p.tile.player = nil
end

function map:setPlayer(p,sx,sy,ex,ey)
	ex , ey = ex or sx , ey or sy
	for x = sx , ex , math.sign(ex - sx) == 0 and 1 or math.sign(ex - sx) do
		for y = sy , ey , math.sign(ey - sy) == 0 and 1 or math.sign(ey - sy) do
			if self[p.x][p.y].player then
				self:removePlayer( self[p.x][p.y].player )
			end
			self:addPlayer( p:new({x = x, y = y}) )
		end
	end
end

function map:deletPlayer(sx,sy,ex,ey)
	ex , ey = ex or sx , ey or sy
	for x = sx, ex, (math.sign(ex - sx) == 0 and 1 or math.sign(ex - sx)) do
		for y = sy, ey,  (math.sign(ey - sy) == 0 and 1 or math.sign(ey - sy)) do
			if self[p.x][p.y].player then
				self:removePlayer( self[x][y].player )
			end
		end
	end
end

--object

function map:setObject(o,sx,sy,ex,ey)
	ex , ey = ex or sx , ey or sy
	local dx = (math.sign(ex - sx) == 0 and 1 or math.sign(ex - sx))
	local dy = (math.sign(ey - sy) == 0 and 1 or math.sign(ey - sy))
	local bx = dx == 1 and o.width - 1 or 0
	local by = dy == 1 and o.height - 1 or 0
	for x = sx + bx, ex + bx, o.width * dx do
		for y = sy + by, ey + by, o.height * dy do
			self[x][y]:setObject( o:new() )
		end
	end
end

function map:deletObject(sx,sy,ex,ey)
	ex , ey = ex or sx , ey or sy
	for x = sx, ex, (math.sign(ex - sx) == 0 and 1 or math.sign(ex - sx)) do
		for y = sy, ey, (math.sign(ey - sy) == 0 and 1 or math.sign(ey - sy)) do
			self[x][y]:deletObject()
		end
	end
end

--item

function map:setItem(i,sx,sy,ex,ey)
	ex , ey = ex or sx , ey or sy
	for x = sx, ex, (math.sign(ex - sx) == 0 and 1 or math.sign(ex - sx)) do
		for y = sy, ey, (math.sign(ey - sy) == 0 and 1 or math.sign(ey - sy)) do
			self[x][y]:setItem( i:new() )
		end
	end
end

function map:deletItem(sx,sy,ex,ey)
	ex , ey = ex or sx , ey or sy
	for x = sx, ex, (math.sign(ex - sx) == 0 and 1 or math.sign(ex - sx)) do
		for y = sy, ey, (math.sign(ey - sy) == 0 and 1 or math.sign(ey - sy)) do
			self[x][y]:deletItem()
		end
	end
end

--positioning

function map:setPos(x,y)
	if x then
		if system.settings.tiles.clamp then
			self.x = math.clamp(x , 1 , self.width - screen.width / system.settings.tiles.scale + 1)
		else
			self.x = x
		end
	end
	if y then
		if system.settings.tiles.clamp then
			self.y = math.clamp(y , 1 , self.height - screen.height / system.settings.tiles.scale + 1)
		else
			self.y = y
		end
	end
end

function map:move(dx,dy)
	self:setPos(self.x - dx , self.y - dy)
end

--outher

function map:nextTurn()
	self.position = self.position + 1
	if self.position > #self.players then
		self.turn = self.turn + 1
		self.position = 1
	end
	if #self.players ~= 0 then
		self.player = self.players[self.position]
		self.player:turn()
	end
	if system.tabs.current then
		system.tabs.current:dofunc("turn",self)
	end
end

function map:save()
	return system.tiles:format(self, {
		get = function(self, x)
			if type(x) ~= "number" then return nil end
			if x > self.width then return "" end
			local s = "\n["..x.."] = {"
			for y = 1, self.height do
				s = s.."["..y.."] = "..tostring( self[x][y] )..", "
			end
			return s.."}"
		end
	})
end

--load

system.tiles.maps = {}

return map