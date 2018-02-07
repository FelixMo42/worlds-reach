function love.graphics.prints(t,x,y,w,h,xa,ya)
	if type(t) == "function" then t = t(x,y,w,h,xa,ya) end
	ya , t = ya or "center" , t..""
	if ya == "center" then
		y = y + h / 2 -  love.graphics.getTextHeight(t,w)/2
	elseif ya == "bottom" then
		y = y + h - love.graphics.getTextHeight(t,w)
	end
	love.graphics.printf(t,x,y,w,xa or "center")
end

function love.graphics.getTextHeight(t,w)
	return #( ( {love.graphics.getFont():getWrap(t,w or screen.width)} )[2] ) * love.graphics.getFont():getHeight()
end

function love.graphics.getTextWidth(t,w)
	return love.graphics.getFont():getWrap(t,w or screen.width)
end

function love.graphics.getTextSize(t,w)
	return love.graphics.getTextWidth(t,w) , love.graphics.getTextHeight(t,w)
end