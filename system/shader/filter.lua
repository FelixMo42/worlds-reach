local filter = system.shader.shader:new({
	filter = "system/shader/filter.glsl",
	varibles = {
		kernel = {
			{-1 , -1 , -1},
			{-1 ,  8 , -1},
			{-1 , -1 , -1}
		},
		color = { 0.4 , 1 , 0.1 },
		step = {0.001 , 0.001}
	}
})

return filter