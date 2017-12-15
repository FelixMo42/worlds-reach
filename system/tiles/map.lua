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
			self[x][y] = self[x][y] or (self.default or system.tiles.tile):new()
			self[x][y].map = self
			self[x][y].x = x
			self[x][y].y = y
		end
	end
	if #self.players > 0 then
		self:nextTurn()
	end
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

function map:addPlayer(p, x, y)
	p.x = x or p.x
	p.y = y or p.y
	if self[p.x][p.y].player then return false , self[p.x][p.y].player end
	p.map = self
	self.players[#self.players + 1] = p
	p.tile = self[p.x][p.y]
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

function map:setTile(t,sx,sy,ex,ey)
	ex , ey = ex or sx , ey or sy
	for x = sx , ex , math.sign(ex - sx) == 0 and 1 or math.sign(ex - sx) do
		for y = sy , ey , math.sign(ey - sy) == 0 and 1 or math.sign(ey - sy) do
			table.set( self[x][y] , self[x][y]:new( t ) )
		end
	end
end

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

function map:nextTurn()
	self.position = self.position + 1
	if self.position > #self.players then
		self.turn = self.turn + 1
		self.position = 1
	end
	self.player = self.players[self.position]
	self.player:turn()
	if system.tabs.current then
		system.tabs.current:dofunc("turn",self)
	end
end

--load

system.tiles.maps = {}

return map