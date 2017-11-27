--system.update

system.update.updated = {}

system.update.globalize = function(l,f,t)
	(t or _G)[l] = (f or system)[l]
end

system.update.folder = function(f)
	for i , path in pairs(system.filesystem:getDirectory(system.update.directory.."system/"..f)) do
		system.update:update("system/"..f..path)
	end
end

system.update.include = function(f,g)
	if not system.update.updated[f] then
		system.update.folder(f.."/")
	end
	system.update.updated[f] = true
	return require("system/"..f , "system/"..f.."/" , g)
end

system.update.addmetamethod = function(k,p)
	p = p or "raw"
	if not _G[p..k] then
		_G[p..k] = _G[k]
	end
	_G[k] = function(i,...)
		local mt = getmetatable(i)
		if mt and mt["__"..k] then return mt["__"..k](i,...) end
		return _G[p..k](i,...)
	end
end

--table

table.copy = function(t , i , l , k)
	local n , i , l = {} , i or -1 , l or {}
	for k , v in rawpairs(t) do
		if type(v) == "table" then
			if not l[v] and i ~= 0 then
				l[v] = {}
				table.set( l[v] , table.copy(v , i - 1 , l , k) )
			end
			n[k] = l[v]
		else
			n[k] = v
		end
	end
	local m = debug.getmetatable( t )
	if m then
		if not l[m] then
			l[m] = {}
			table.set( l[m] , table.copy(m , -1 , l) )
		end
		rawsetmetatable( n , l[m] )
	end
	str = ""
	return n
end

table.set = function(t , n , s)
	for k , v in rawpairs(n) do
		t[k] = v
	end
	rawsetmetatable( t , debug.getmetatable(n) )
end

table.size = function(t)
	l = 0
	for k , v in pairs(t) do
		l = l + 1
	end
	return l
end

--love

love.graphics.prints = function(t,x,y,w,h,xa,ya)
	if not ya or ya == "center" then
		local l = #( ( {love.graphics.getFont():getWrap(t,w)} )[2] )
		y = y + h / 2 -  (l * love.graphics.getFont():getHeight())/2
	elseif ya == "bottom" then
		local l = #( ( {love.graphics.getFont():getWrap(t,w)} )[2] )
		y = y + h - (l * love.graphics.getFont():getHeight())
	end
	love.graphics.printf(t,x,y,w,xa or "center")
end

--setup

function inext(t, var)
	var = var + 1
	local value = t[var]
	if value == nil then return end
	return var, value
end

function ipairs(t,...)
	local mt = getmetatable(t)
	if mt and mt["__ipairs"] then return mt["__ipairs"](t,...) end 
	return inext, t, 0
end

rawpairs = pairs

function pairs(t,...)
	local mt = getmetatable(t)
	if mt and mt["__pairs"] then return mt["__pairs"](t,...) end 
	return next, t, nil
end

system.update.addmetamethod("next")
system.update.addmetamethod("setmetatable")
system.update.addmetamethod("type")