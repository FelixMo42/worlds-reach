local shader = class:new({
	type = "shader",
	styles = {},
	varibles = {}
})

function shader:__init(orig)
	if not self.filter then return end
	self.object = love.graphics.newShader(self.filter)
	self.styles.default = self.varibles
	self:setStyle( "default" , false )
end

function shader:__set(k,v)
	if self.varibles[k] then
		if not self.styles[self.style][k] or self.override then
			self.object:send( k , v )
		end
	end
	return false
end

function shader:setStyle(style, override)
	self.style = style
	self.override = override
	if override == nil then override = true end
	for k , v in pairs(self.styles[style]) do
		if override or not self[k] then
			self.object:send( k , v )
		elseif self[k] then
			self.object:send( k , self[k] )
		end
	end
end

function shader:activate()
	love.graphics.setShader(self.object)
end

function shader:deactivate()
	love.graphics.setShader()
end

return shader