local skill = class:new({
	type = "skill", name = "def",
	state = "str",
	level = 0
})

--functions

function skill:__tostring()
	return system.tiles:tostring( self )
end

--load

system.tiles.skills = {}

return skill