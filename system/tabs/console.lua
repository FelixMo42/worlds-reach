local console = class:new({
	type = "console",
	split = " ", input = "",
	enter = function() end,
	active = true, log = {},
	direction = 1
})

function console:dofunc(f,...)
	if self[f] then
		return self[f](self,...)
	end
end

function console:print(...)
	self.log[#self.log + 1] = {...}
end

function console:draw()
	--set up local varibles
	local y = self.y or love.graphics.getFont():getHeight() / 2
	local d = math.abs(math.max(self.direction , #self.log * self.direction))
	--set color and font
	if self.color then love.graphics.setColor(self.color) end
	if self.font then love.graphics.setFont(self.font) end
	--get msg
	for i = (#self.log + 1) - d , d , self.direction do
		local text = self:msg(i)
		--print text
		love.graphics.printf(text , self.x or 5 , y , love.graphics.getWidth() - 20)
		y = y + love.graphics.getTextHeight(text) * self.direction
	end
	--print input
	love.graphics.print(self.input , self.x or 5 , love.graphics.getHeight() - love.graphics.getFont():getHeight() * 1.5)
end

function console:msg(i)
	if not self.log[i] then return "" end
	local text = ""
	for i , v in pairs( self.log[i] ) do
		if type(v) == "function" then
			text = text..tostring(v())
		else
			text = text..tostring(v)
		end
		if i ~= #self.log[i] then
			text = text..self.split
		end
	end
	return text
end

function console:textinput(text)
	if not self.active then return end
    self.input = self.input..text
end

function console:keypressed(key)
	if not self.active then return end
    if key == "backspace" then
        self.input = string.sub(self.input, 1, -2)
    elseif key == "return" then
    	self:enter(self.input)
    	self:print(self.input)
    	self.input = ""
    end
end

function console:enter()
end

function console:clear(reset)
	self.log = {}
	if reset then
		self.enter = function() end
	end
end

function console:getWidth()
	local width = 0
	for i = 1, #self.log do
		local text = self:msg(i)
		local w = love.graphics.getTextWidth(text)
		if w > width then
			width = w
		end
	end
	return width
end

function console:getHeight()
	local height = 0
	for i = 1, #self.log do
		local text = self:msg(i)
		height = height + love.graphics.getTextHeight(text)
	end
	return height
end

return console