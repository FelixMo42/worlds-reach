menu.ui:add( ui.button:new({
	text = "new game\n───────\n\n\n\n\n\n", font = font[24],
	sy = .3, ey = .4, width = 0, height = 0, ex = .2, x = 10, edge = 20,
	func = function()
		love.open( game )
	end
}) )

function menu.draw()
	love.graphics.setFont( font:sget(31,"bold") )
	love.graphics.printf(" Worlds Reach ",0,10,screen.width,"center")
	love.graphics.line( 0,screen.height*.3 - 10 , screen.width,screen.height*.3 - 10 )
	love.graphics.line( 0,screen.height*.7 + 10 , screen.width,screen.height*.7 + 10 )
end