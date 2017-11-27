--set up world

game.tab:addLayer( "world" )

game.map = map:new()
game.team = {player:new({
	x = 1, y = 1,
	name = "The big MC man",
	actions = { actions.fireBolt },
	ai = {
		contoller = "player",
		mode = "s",
		turn = function(self)
			if self.ai.mode == "i" then
				for k in pairs(self.moves) do
					self.moves[k] = math.huge
				end
			end
		end
	}
})}

for i , p in pairs(game.team) do
	game.map:addPlayer( p )
end

game.map:addPlayer( player:new({
	x = 5, y = 5,
	ai = {
		contoller = "computer",
		turn = function(self)
			self.actions.move(self.x + 1,self.y)
			self.actions.endTurn()
		end
	}
}) )

game.world:add( game.map )

mouse.tile = {}
mouse.tile.sx , mouse.tile.sy = 0 , 0
mouse.tile.ex , mouse.tile.ey = 0 , 0
mouse.tile.x , mouse.tile.y = 0 , 0

game.map:nextTurn()

--ui

game.button = ui.button:new({over_b = 0, edge = 0, font = font.default})
game.menu = ui.menu:new({over_b = 0, edge = 0, font = font.default})

game.ui:add( game.menu:new({
	text = "actions",
	setUp = function(self)
		self.child:clear()
		if game.map.player.ai.contoller == "player" then
			self.textColor = color.white
			local y = 20
			local sections = {}
			for k , v in pairs(game.map.player.actions) do
				if v.section then
					if not sections[v.section] then
						sections[v.section] = self:addChild( game.menu:new({
							x = 0, y = y, yd = 20, text = v.section
						}) )
						y = y + 20
					end
					sections[v.section]:addChild( game.button:new({
						x = 100, y = sections[v.section].yd, action = v,
						text = v.name, func = function(self)
							if self.action.instant then
								self.action(self.action,0,0)
							else
								game.action = self.action
							end
						end
					}) )
					sections[v.section].yd = sections[v.section].yd + 20
				end
			end
		else
			self.textColor = color.grey
		end
	end
}) , "actions" )

game.ui:add( game.button:new({
	text = "inventory",
	x = 100,
	func = function()
		love.open( inventory )
	end
}) , "inventory" )

game.ui:add( system.console:new({
	direction = -1,
	color = color.black,
	y = screen.height - 25,
	font = font:sget(12,"bold"),
	active = false
}) , "info" )

game.ui.info:print("───────────────")
game.ui.info:print("action: ", function() return game.action.name end)
game.ui.info:print("player: ", function() return game.map.player.name end)

for k , p in pairs(game.team) do
	local ui = game.ui:add( game.button:new({
		width = 60, height = 60, text = p.name,
		x = function() return screen.width - 65 end,
		y = function() return screen.height - 65 end
	}) )
end

--functions

function game.open()
	love.graphics.setFont( font.default )
	game.turn()
end

function game.turn()
	game.ui.actions:setUp()
	game.action = actions.move
end

function game.update(dt)
	local px = game.map.player.gx - (screen.width / settings.tiles.scale) / 2 + .5
	local py = game.map.player.gy - (screen.height / settings.tiles.scale) / 2 + .5
	game.map:setPos( px , py )

	if game.map.player.ai.contoller == "player" then
		if #game.map.player.queue == 0 then
			if love.keyboard.isDown("w") then
				game.map.player.actions.move(game.map.player.x,game.map.player.y - 1)
			elseif love.keyboard.isDown("s") then
				game.map.player.actions.move(game.map.player.x,game.map.player.y + 1)
			elseif love.keyboard.isDown("a") then
				game.map.player.actions.move(game.map.player.x - 1,game.map.player.y)
			elseif love.keyboard.isDown("d") then
				game.map.player.actions.move(game.map.player.x + 1,game.map.player.y)
			end
		end

		if game.map.player.ai.mode == "s" then
			for move , value in pairs(game.map.player.moves) do
				if value <= 0 then
					game.map:nextTurn()
				end
			end
		end
	end
end

function game.mousemoved(x,y,dx,dy)
	mouse.tile.sx = math.floor(mouse.sx / settings.tiles.scale + game.map.x)
	mouse.tile.sy = math.floor(mouse.sy / settings.tiles.scale + game.map.y)
	mouse.tile.ex = math.floor(mouse.ex / settings.tiles.scale + game.map.x)
	mouse.tile.ey = math.floor(mouse.ey / settings.tiles.scale + game.map.y)
	mouse.tile.x = math.floor(mouse.x / settings.tiles.scale + game.map.x)
	mouse.tile.y = math.floor(mouse.y / settings.tiles.scale + game.map.y)
end

function game.mousereleased()
	if not mouse.used and game.map.player.ai.contoller == "player" then
		if game.action.name == "move" then
			game.map.player:goto( mouse.tile.x , mouse.tile.y )
		else
			game.action( mouse.tile.x , mouse.tile.y )
			game.action = actions.move
		end
	end
end