local action = class:new({
	type = "action", name = "def",
	moveType = "main", moves = 1,
	styles = {}, style = "bolt",
	Dmin = 1, Dmax = 5, Dtype = "physical",
	range = 1, width = 1, height = 2,
	cost = 0, health = 0
})

--functions

function action:__call(x,y,...)
	--cheak if possible
	if not self.player then return false end
	if not self:cheak(x,y,...) then return false end
	--do it
	self.player:useEnergy(self.moveType, self.moves)
	if self.drawFunc then
		self.player.queue:add(self, x,y)
	end
	return (self.func or self.styles[self.style].func)(self, x,y , ...) or true
end

function action:__tostring()
	return system.tiles:tostring( self )
end

function action:cheak(x,y,...)
	if not (self.possible or self.styles[self.style].possible)(self , x,y , ...) then return false end
	if self.player.moves[self.moveType] < self.moves then return false end
	return true
end

function action:damage(t)
	t:HP( -math.random( self.Dmin , self.Dmax ) , self.Dtype , self.player )
end

function action:draw(sx,sy , ex,ey)
	self.styles[self.style].draw(self, sx,sy , ex,ey)
end

setmetatable( action.styles , {
	__type = function() return "data" end,
	__index = { add = function(self,name,value)
		self[name] = value
	end }
} )

action.styles:add( "bolt" , {
	func = function(self,x,y,...)
		if self.player.map[x][y].player then
			self:damage( self.player.map[x][y].player )
		end
	end,
	possible = function(self,x,y,...)
		return system.tiles.path:line(self.player.map , self.player.x,self.player.y , x,y , self)
	end,
	draw = function(self, sx,sy , ex,ey)
		love.graphics.setColor( system.ui.color.black )
		love.graphics.line(sx,sy , ex,ey)
		love.graphics.circle("line",ex,ey,system.settings.tiles.scale/2 + system.settings.tiles.scale * (self.width - 1))
	end
})

--load

system.tiles.actions = {}

system.tiles.actions.move = action:new({
	id = "move", name = "move",
	moveType = "movement",
	height = 0, last = true,
	func = function(self,x,y)
		self.player:setPos(x,y)
	end,
	drawFunc = function(self,x,y,dt)
		local self = self.player
		self.px, self.py = self.px or self.gx, self.py or self.gy
		local d = 1 / math.sqrt( (x - self.px) ^ 2 + (y - self.py) ^ 2 )
	 	self.gx = self.gx + ( math.sign(x - self.px) * dt * system.settings.tiles.speed * d )
		self.gy = self.gy + ( math.sign(y - self.py) * dt * system.settings.tiles.speed * d )
		local cx = math.abs(self.gx - self.px) >= math.abs(x - self.px)
		local cy = math.abs(self.gy - self.py) >= math.abs(y - self.py)
		local s = "front"
		if x - self.px < 0 then
			s = "right"
		elseif x - self.px > 0 then
			s = "left"
		elseif y - self.py < 0 then
			s = "back"
		elseif y - self.py > 0 then
			s = "front"
		end
		if cx and cy then
			self.gx, self.gy = x, y
			self.px, self.py = nil, nil
			if self.sprites and self.sprites[s] then
				self.sprite = self.sprites[s][0]
			end
			return false
		end
		if self.sprites and self.sprites[s] then
			local n = (math.floor(self.px + self.py) % (#self.sprites[s] * 2)) + 1
			if n % 2 == 0 then
				self.sprite = self.sprites[s][n / 2]
			else
				self.sprite = self.sprites[s][0]
			end
		end
		return true
	end,
	draw = function(self,sx,sy,ex,ey)
		love.graphics.setColor( system.ui.color.black )
		love.graphics.circle("line",ex,ey,system.settings.tiles.scale/2 )
	end
})

system.tiles.actions.endTurn = action:new({
	id = "endTurn", name = "end turn",
	moves = 0,
	func = function(self)
		self.player.map:nextTurn()
	end,
	cheak = function(self,x,y)
		return true
	end
})

return action