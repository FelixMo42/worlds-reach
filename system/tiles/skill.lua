local skill = class:new({
	type = "skill", name = "def",
	state = "str",
	level = 0
})

--functions

function skill:__tostring()
	local s = "system.tiles."
	if self.file then
		s = s.."skills."..self.file..":new({"
	else
		s = s.."skill:new({"
	end
	return s.."})"
end

--load

system.tiles.skills = {}

return skill