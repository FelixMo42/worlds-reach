menu.ui:add( ui.button:new({
	text = "new game\n───────\n\n\n\n\n\n", font = font[24],
	sy = .3, ey = .4, width = 0, height = 0, ex = .2, x = 10, edge = 20,
	func = function() love.open( game ) end
}) )

function menu.open()
	love.open( game )
end

function menu.load()
	love.graphics.setDefaultFilter( "nearest", "nearest" )
	tileSheet = spriteSheet:new({path = "data/TileSheet.png"})
	spriteSheet = spriteSheet:new({path = "data/SpriteSheet.png"})

	objects.wall.sprite = tileSheet.sprites["floor"]
	objects.wall.sprites = {}
	objects.wall.sprites["*-* +*+ *-*"] = tileSheet:addSprite("wall *-* +*+ *-*",7,3,1,2,0,1) -- 1
	objects.wall.sprites["*-* -*+ *-*"] = tileSheet:addSprite("wall *-* -*+ *-*",6,3,1,2,0,1) -- 2
	objects.wall.sprites["*+* +*- *-*"] = tileSheet:addSprite("wall *+* +*- *-*",8,8,1,1,0,0) -- 3
	objects.wall.sprites["*+* -*- -+-"] = tileSheet:addSprite("wall *+* -*- -+-",0,5,1,1,0,0) -- 4
	objects.wall.sprites["*+* -*- ++-"] = tileSheet:addSprite("wall *+* -*- ++-",4,7,1,1,0,0) -- 5
	objects.wall.sprites["*-* -*- -+-"] = tileSheet:addSprite("wall *-* -*- -+-",0,3,1,2,0,1) -- 6
	objects.wall.sprites["*-* -*+ -+-"] = tileSheet:addSprite("wall *-* -*+ -+-",2,5,1,2,0,1) -- 7
	objects.wall.sprites["*-* +*- -+-"] = tileSheet:addSprite("wall *-* +*- -+-",4,5,1,2,0,1) -- 8
	objects.wall.sprites["*+* -*- *-*"] = tileSheet:addSprite("wall *+* -*- *-*",0,6,1,1,0,0) -- 9
	objects.wall.sprites["*+* -*+ *-*"] = tileSheet:addSprite("wall *+* -*+ *-*",6,8,1,1,0,0) -- 10
	objects.wall.sprites["*+* -*- -++"] = tileSheet:addSprite("wall *+* -*- -++",2,7,1,1,0,0) -- 11
	objects.wall.sprites["*+* +*+ *-*"] = tileSheet:addSprite("wall *+* +*+ *-*",7,8,1,1,0,0) -- 12
	objects.wall.sprites["*+* +*+ +++"] = tileSheet:addSprite("wall *+* +*+ +++",7,7,1,1,0,0) -- 13
	objects.wall.sprites["*-* +*+ +++"] = tileSheet:addSprite("wall *-* +*+ *+*",7,5,1,2,0,1) -- 14
	objects.wall.sprites["*-* -*+ -++"] = tileSheet:addSprite("wall *-* -*+ -++",6,5,1,2,0,1) -- 15
	objects.wall.sprites["*-* +*- ++*"] = tileSheet:addSprite("wall *-* +*- *+*",8,5,1,2,0,1) -- 16
	objects.wall.sprites["*+* -*+ -++"] = tileSheet:addSprite("wall *+* -*+ -++",6,7,1,1,0,0) -- 17
	objects.wall.sprites["*+* +*- ++-"] = tileSheet:addSprite("wall *+* +*- ++-",8,7,1,1,0,0) -- 18
	objects.wall.sprites["*-* -*- *-*"] = tileSheet:addSprite("wall *-* -*- *-*",0,1,1,2,0,1) -- 19
	objects.wall.sprites["*-* +*- *-*"] = tileSheet:addSprite("wall *-* +*- *-*",8,3,1,2,0,1) -- 20
	objects.wall.sprites["*-* +*+ -+-"] = tileSheet:addSprite("wall *-* +*+ -+-",4,3,1,2,0,1) -- 21
	objects.wall.sprites["*-* -*- +++"] = tileSheet:addSprite("wall *-* -*- +++",2,3,1,2,0,1) -- 22
	objects.wall.sprites["*+* +*- +++"] = tileSheet:addSprite("wall *+* +*- +++",0,8,1,1,0,0) -- 23
	objects.wall.sprites["*+* -*+ +++"] = tileSheet:addSprite("wall *+* +*- +++",0,9,1,1,0,0) -- 24
	objects.wall.sprites["*+* +*+ ++-"] = tileSheet:addSprite("wall *+* +*- +++",1,8,1,1,0,0) -- 25
	objects.wall.sprites["*+* +*+ -++"] = tileSheet:addSprite("wall *+* +*- +++",1,9,1,1,0,0) -- 26
	objects.wall.sprites["*+* -*- +++"] = tileSheet:addSprite("wall *+* +*- +++",2,2,1,1,0,0) -- 27
	objects.wall.sprites["*-* +*- +++"] = tileSheet:addSprite("wall *-* +*- ++-",7,1,1,2,0,1) -- 28
	objects.wall.sprites["*-* -*+ +++"] = tileSheet:addSprite("wall *-* +*- ++-",8,1,1,2,0,1) -- 29
	objects.wall.sprites["*-* -*- -++"] = tileSheet:addSprite("wall *-* +*- ++-",5,1,1,2,0,1) -- 30
	objects.wall.sprites["*-* -*- ++-"] = tileSheet:addSprite("wall *-* +*- ++-",6,1,1,2,0,1) -- 31
	objects.wall.sprites["*+* -*+ -+-"] = tileSheet:addSprite("wall *-* +*- ++-",3,8,1,1,0,0) -- 32
	objects.wall.sprites["*+* +*- -+-"] = tileSheet:addSprite("wall *-* +*- ++-",3,9,1,1,0,0) -- 33
	objects.wall.sprites["*-* +*+ -++"] = tileSheet:addSprite("wall *-* +*- ++-",2,0,1,2,0,1) -- 34
	objects.wall.sprites["*-* +*+ ++-"] = tileSheet:addSprite("wall *-* +*- ++-",3,0,1,2,0,1) -- 35

	local playerSprites = {
		front = { [0] = spriteSheet:addSprite("F0",0,0,1,2,0,1) , spriteSheet:addSprite("F1",1,0,1,2,0,1) , spriteSheet:addSprite("F2",2,0,1,2,0,1) },
		right = { [0] = spriteSheet:addSprite("R0",0,2,1,2,0,1) , spriteSheet:addSprite("R1",1,2,1,2,0,1) , spriteSheet:addSprite("R2",2,2,1,2,0,1) },
		left = { [0] = spriteSheet:addSprite("L0",2,4,1,2,0,1) , spriteSheet:addSprite("L1",1,4,1,2,0,1) , spriteSheet:addSprite("L2",0,4,1,2,0,1) },
		back = { [0] = spriteSheet:addSprite("B0",0,6,1,2,0,1) , spriteSheet:addSprite("B1",1,6,1,2,0,1) , spriteSheet:addSprite("B2",2,6,1,2,0,1) }
	}

	tiles.grass.sprite = tileSheet:addSprite("floor",0,0,1,1,0,0)

	for x = 1, maps.QH.width do
		for y = 1, maps.QH.height do
			maps.QH[x][y].color = color.white
			maps.QH[x][y].sprite = tiles.grass.sprite
			if maps.QH[x][y].object then
				maps.QH[x][y].object.color = color.white
				maps.QH[x][y].object.sprite = objects.wall.sprite
				maps.QH[x][y].object.sprites = objects.wall.sprites
			end
			if maps.QH[x][y].player then
				maps.QH[x][y].player.color = color.white
				maps.QH[x][y].player.sprite = spriteSheet.sprites["F0"]
				maps.QH[x][y].player.sprites = playerSprites
			end
		end
	end
end

function menu.draw()
	love.graphics.setFont( font:sget(31,"bold") )
	love.graphics.printf(" Worlds Reach ",0,10,screen.width,"center")
	love.graphics.line( 0, screen.height * .3 - 10 , screen.width, screen.height * .3 - 10 )
	love.graphics.line( 0, screen.height * .7 + 10 , screen.width, screen.height * .7 + 10 )
end