math.rawsqrt = math.sqrt
math.sqrts = {}

math.sqrt = function(n)
	if math.sqrts[n] then return math.sqrts[n] end
	return math.rawsqrt(n)
end

math.dist = function(sx,sy , ex,ey)
	return math.floor(math.sqrt((sx-ex)^2+(sy-ey)^2)*10)
end

math.clamp = function(val,min,max)
	return math.min( math.max(val + 0,min + 0) , max + 0)
end

math.loop = function(val,max,min)
	if min then
		local m = min
		min = max
		max = m
	else
		min = 1
	end
	if val > max then
		val = min + (val - max - 1)
	end
	while val < min do
		val = max - (min - val)
	end
	return val
end

math.sign = function(n)
	if n > 0 then
		return 1
	elseif n < 0 then
		return -1
	else
		return 0
	end
end