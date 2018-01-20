--system.update

system.update.updated = {}

function system.update.globalize(l,f,t)
	(t or _G)[l] = (f or system)[l]
end

function system.update.folder (f)
	for i , path in pairs(system.filesystem:getDirectory(system.update.directory.."system/"..f)) do
		system.update:update("system/"..f..path)
	end
end

function system.update.include(f,g)
	if system.filesystem.isApp then return require("system/"..f , "system/"..f.."/" , g) end
	if not system.update.updated[f] then
		system.update.folder(f.."/")
	end
	system.update.updated[f] = true
	return require("system/"..f , "system/"..f.."/" , g)
end

function system.update.addmetamethod(k,p)
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

function table.rawclear(self)
	debug.setmetatable( self , {} )
	for k , v in pairs(self) do
        self[k] = nil
    end
end

function table.set(self, new)
    table.rawclear(self)
    for k , v in rawpairs(new) do
        self[k] = v
    end
    setmetatable( self , debug.getmetatable(new) )
end

function table.copy(t , i , l , k)
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

--setup

function ipairs(t,d,...)
	if not t then
		love.errhand("ipairs expectes table")
		love.event.quit()
	end
	local mt = getmetatable(t)
	if mt and mt["__ipairs"] then return mt["__ipairs"](t,...) end
	local a = d or 1
	local init = a > 0 and 0 or #t
	return function(t, var)
		var = var + a
		local value = t[var]
		if value == nil then return end
		return var, value
	end, t, init
end

--[[function inext(t, var, a)
	var = var + a
	local value = t[var]
	if value == nil then return end
	return var, value
end

function ipairs(t,i,...)
	if not t then
		love.errhand("ipairs expectes table")
		love.event.quit()
	end
	local mt = getmetatable(t)
	if mt and mt["__ipairs"] then return mt["__ipairs"](t,...) end
	local init = (i or 1) > 0 and 0 or #t
	return funk, t, init, d
end]]

rawpairs = pairs

function pairs(t,i,...)
	local mt = getmetatable(t)
	if mt and mt["__pairs"] then return mt["__pairs"](t,...) end 
	return next, t, nil
end

system.update.addmetamethod("next")
system.update.addmetamethod("setmetatable")
system.update.addmetamethod("type")