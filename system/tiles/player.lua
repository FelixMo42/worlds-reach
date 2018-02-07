local player = class:new({
	type = "player", name = "def",
	stats = {
		int = 0, wil = 0, chr = 0,
		str = 0, con = 0, dex = 0,
	},
	moves = {movement = 5, main = 1, sub = 2},
	actions = {},
	x = 1, y = 1, gx = 1, gy = 1, px = 1, py = 1,
	level = 1, xp = 0,
	mp = 20, hp = 20,
	queue = {}, ai = {},
	color = color.blue
})

--functions

function player:__init()
	--set up graphics
	self.gx, self.gy = self.x, self.y
	self.px, self.py = self.x, self.y
	self.maxHp , self.maxMp = self.hp , self.mp
	--set up moves
	local t = {}
	setmetatable( self.moves , { __index = t } )
	for k , v in pairs(self.moves) do
		t[k.."_max"] = v
	end
	--set up actions
	for key , action in pairs(self.actions) do
		if type(key) == "number" then
			self:addAction( action:new() )
			self.actions[key] = nil
		end
	end
	self:addAction( system.tiles.actions.move:new() )
	self:addAction( system.tiles.actions.endTurn:new() )
end

function player:__tostring()
	return system.tiles:tostring( self , {
		tile = function() return "" end
	} )
end

function player:draw(x, y, s)
	local x = x or (self.gx - self.map.x) * system.settings.tiles.scale
	local y = y or (self.gy - self.map.y) * system.settings.tiles.scale
	local s = s or system.settings.tiles.scale
	love.graphics.setColor(self.color)
	if self.sprite then
		self.sprite(x , y , s , s)
	else
		love.graphics.circle("fill" , x + .5 * s, y + .5 * s , s / 2 , s / 2 )
	end
end

function player:update(dt)
	if #self.queue == 0 then return true end
	if not self.queue[1].func(self.queue[1].type,self.queue[1].x,self.queue[1].y,dt,self.queue[1]) then
		table.remove(self.queue , 1)
		return self:update(dt)
	end
	return false
end

function player:turn()
	for k in pairs(self.moves) do
		self.moves[k] = self.moves[k.."_max"]
	end
	if self.ai.turn then
		self.ai.turn( self )
	end
end

function player:addAction(action)
	self.actions[action.id or action.name] = action
	action.player = self
end

function player:setPos(x,y)
	self.x , self.y = x , y
	self.map[x][y]:setPlayer( self )
end

function player:useEnergy(type, amu)
	self.moves[type] = self.moves[type] - amu
	for move , value in pairs(self.moves) do
		if not move:find("_max") and value > 0 then
			return true
		end
	end
	self.map:nextTurn()
	return false
end

function player:HP(a,t,s)
	self.hp = math.min(self.hp + a , self.maxHp)
	if self.hp <= 0 then
		if s then
			--s:addXP( self.xp )
		end
		self.map:removePlayer( self )
	end
end

function player.queue:add(action,x,y,drawFunc)
	self[#self + 1] = {x = x, y = y, type = action, func = drawFunc or action.drawFunc}
end

--load

system.tiles.players = {}

return player