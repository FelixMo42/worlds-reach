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
    debug.setmetatable( self , debug.getmetatable(new) )
end

function table.copy(t , s)
	local n = {}
	local s = s or { [t] = n }
	for k , v in rawpairs(t) do
		if type(v) == "table" and not s[v] then
			s[v] = {}
			table.set( s[v] , table.copy(v , s) )
		end
		n[k] = s[v] or v
	end
	local m = debug.getmetatable( t )
	if m then
		if not s[m] then
			s[m] = {}
			table.set( s[m] , table.copy(m , s) )
		end
		setmetatable( n , s[m] )
	end
	return n
end

--setup

function ipairs(t,d,...)
	if not t then
		love.errhand("ipairs expectes table")
		love.event.quit()
	end
	local mt = getmetatable(t)
	if mt and mt["__ipairs"] then
		if type(mt["__ipairs"]) == "function" then
			return mt["__ipairs"](t,...)
		end
		return ipairs( mt["__ipairs"] )
	end
	local a = d or 1
	local init = a > 0 and 0 or #t
	return function(t, var)
		var = var + a
		local value = t[var]
		if value == nil then return end
		return var, value
	end, t, init
end

rawpairs = pairs

function pairs(t,i,...)
	local mt = getmetatable(t)
	if mt and mt["__pairs"] then
		if type(mt["__pairs"]) == "function" then
			return mt["__pairs"](t,...)
		end
		return pairs( mt["__pairs"] )
	end
	return next, t, nil
end

system.update.addmetamethod("next")
system.update.addmetamethod("setmetatable")
system.update.addmetamethod("type")