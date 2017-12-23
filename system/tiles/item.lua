local item = class:new({
	type = "item", name = "def",
	color = {255,255,255}
})

--functions

function item:__tostring()
	local s = "system.tiles."
	if self.file then
		s = s.."items."..self.file..":new({"
	else
		s = s.."item:new({"
	end
	return s.."})"
end

function item:draw(x,y,s)
	love.graphics.setColor(self.color)
	love.graphics.rectangle("fill",x + s/10,y + s/10,s - s/5,s - s/5)
end

--load

system.tiles.items = {}

return item