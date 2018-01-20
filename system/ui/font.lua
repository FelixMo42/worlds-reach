local font = setmetatable( {} , {
	__index = function(self,key)
		if key == "current" then
			return love.graphics.getFont()
		elseif type(key) == "number" then
			return self:get(key)
		end
	end
} )

function font:get(i , font , style)
	local font = font or self.font
	local style = style or self.style
	local index = ""
	if style then
		index = font.." "..style..".ttf"
	else
		index = font..".ttf"
	end
	if not self.fonts[index] then self.fonts[index] = {} end
	if self.fonts[index][i] then return self.fonts[index][i] end
	self.fonts[index][i] = love.graphics.newFont(index, i)
	return self.fonts[index][i]
end

function font:sget(i , style)
	return font:get(i , nil , style)
end

font.fonts = {}

font.font = "system/ui/Verdana"

font.default = font[font.current:getHeight()]

love.graphics.setFont( font.default )

return font