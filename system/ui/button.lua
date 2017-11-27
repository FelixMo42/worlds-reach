local button = system.ui.object:new({
	type = "button",
	width = 100, height = 20, b = 0,
	bodyColor = {0,0,0},
	lineColor = {255,255,255},
	textColor = {255,255,255},
	sx = 0, sy = 0,
	ex = 0, ey = 0,
	x = 0, y = 0,
	text = "button",
	getmode = "norm",
	over = false,
	pressed = false,
	over_b = 4,
	modes = {
		"pressed",
		"over"
	}
})

local function modeget(self , key)
	if type(key) == "string" then
		for i , mode in ipairs( self._modes ) do
			if self["_"..mode] and self[mode.."_"..key] then
				return self[mode.."_"..key]
			end
		end
	end
	return self["_"..key]
end

local function calc(v , self)
	if type(v) == "function" then return v(self) end
	return v
end

local getter = {}

function button:__get(key)
	if getter[key] then return getter[key](self,key) end
	local mt = getmetatable(self)
	if mt.__getter[key] then return mt.__getter[key](self,key) end
	if type(key) == "string" and key:find("_") then
		if key:sub(1,1) == "_" then
			return mt.__values[key:sub(2)]
		else
			return mt.__values[key]
		end
	end
	return modeget(self , key)
end

getter.x = function(self)
	local x = calc(modeget(self , "x"))
	return (system.screen.width * self.sx) + ( x - ( self.bl or ( (self.bw or self.b) / 2 ) ) )
end

getter.y = function(self)
	local y = calc(modeget(self , "y"))
	return (system.screen.height * self.sy) + ( y - ( self.bu or ( (self.bh or self.b) / 2 ) ) )
end

getter.width = function(self)
	local w = calc(modeget(self,"width"))
	return (system.screen.width * self.ex) + ( w + (self.br or self.bw or self.b) + (self.bl or 0) )
end

getter.height = function(self)
	local h = calc(modeget(self,"height"))
	return (system.screen.height * self.ey) + ( h + (self.bd or self.bh or self.b) + (self.bu or 0) )
end

button:addCallback("draw","body",function(self)
	love.graphics.setColor(self.bodyColor)
	love.graphics.rectangle("fill",self.x,self.y,self.width,self.height,self.edge or 0)
end )

button:addCallback("draw","outline",function(self)
	love.graphics.setColor(self.lineColor)
	love.graphics.rectangle("line",self.x,self.y,self.width,self.height,self.edge or 0)
end )

button:addCallback("draw","text",function(self)
	if self.font then
		love.graphics.setFont( self.font )
	end
	love.graphics.setColor(self.textColor)
	love.graphics.prints(self.text,self.x,self.y,self.width,self.height,self.textMode,self.textAligne)
end )

button:addCallback("mousepressed","pressed",function(self)
	self.pressed = self.over
end )

button:addCallback("mousepressed","used",function(self)
	if not system.mouse.used and self.over then
		system.mouse.used = true
	end
end)

button:addCallback("mousereleased","callFunc",function(self)
	if self.over and self.func and not system.mouse.used then
		self:func()
	end
end )

button:addCallback("mousereleased","used",function(self)
	if not system.mouse.used and self.over then
		system.mouse.used = true
	end
end )

button:addCallback("mousereleased","released",function(self)
	self.pressed = false
end )

button:addCallback("mousemoved","over",function(self,x,y)
	if x > self.x and x < self.x + self.width and y > self.y and y < self.y + self.height then
		self.over = true
	else
		self.over = false
	end
end )

return button