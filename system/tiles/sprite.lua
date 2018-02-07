local sprite = class:new({
	path = "data/grid.png",
	size = 15,
	sprites = {}
})

function sprite:__init()
	self.img = love.graphics.newImage(self.path)
end

function sprite:addSprite(name,x,y,w,h,sx,sy)
	w , h , sx , sy = w or 1, h or 1 , sx or 0 , sy or 0
	local quad = love.graphics.newQuad( x * self.size,y * self.size,w * self.size,h * self.size , self.img:getDimensions() )
	local width = self.size
	local height = self.size
	self.sprites[name] = function(x,y,w,h)
		love.graphics.draw(self.img, quad, x - sx * w,y - sy * h, 0 , w / width , h / height)
	end
	return self.sprites[name]
end

system.tiles.sprites = {}

return sprites