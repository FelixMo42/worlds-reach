local metaaccessor = {
	__index = function(self , key)
		return self.__metamethode[key] or self.__metaindex[key] or self.__values[key]
	end,
	__newindex = function(self , key , value)
		self.__metaindex[key] = value
	end
}

local metamethode = {
	__index = function(self , key)
		local mt = getmetatable(self)
		if mt.__get then return mt.__get(self , key) end
		if mt.__getter[key] then return mt.__getter[key](self , key) end
		if mt.__values[key] then return mt.__values[key] end
	end,
	__newindex = function(self , key , value)
		local mt = getmetatable(self)
		if mt.__set and mt.__set(mt.__values , key , value) ~= false then return end
		if mt.__setter[key] and mt.__setter[k](mt.__values , value , key) ~= false then return end
		mt.__values[key] = value
	end,
	__setmetatable = function(self , new)
		getmetatable(self).__metaindex = new
	end
}

local metaindex = {
	__copy = function(self)
		if self.__copy then return self.__copy( self ) end
		return table.copy( self )
	end,
	__new = function(self, t)
		if self.__new then return self.__new( self ) end
		for k , v in pairs(t or {}) do
			self[k] = v
		end
	end,
	__type = function(self)
		if self.__type then return self.__type( self ) end
		return self.type or "table"
	end,
	__tostring = function(self)
		if self.__tostring then return self.__tostring( self ) end
		return type(self)
	end,
	__next = function(self, value)
		return next(getmetatable(self).__values , value)
	end
}

local metadata = {
	__metamethode = metamethode,
	__metaindex = metaindex,
	__getter = {},
	__setter = {},
	__values = {}
}

local metatable = {
	__metatable = setmetatable(metadata , metaaccessor)
}

local function newmetafunction(key)
	local key = key
	return function(self,...)
		if getmetatable(self)[key] then
			return getmetatable(self)[key](self,...)
		end
	end
end

local love = {"index","newindex","mode","call","tostring","unm","add","sub","mul","div","idiv","len","mod","pow","concat","eq","lt","le"}

for i , k in pairs(love) do
	metatable["__"..k] = newmetafunction("__"..k)
end

local class = setmetatable( {} , metatable )

function getgetter(self , k) return getmetatable(self).__getter[k] end
function setgetter(self , k , v) getmetatable(self).__getter[k] = v; return self end
function getsetter(self , k) return getmetatable(self).__setter[k] end
function setsetter(self , k , v) getmetatable(self).__setter[k] = v; return self end

setgetter( class , "new" , function()
	return function(self,...)
		local new = getmetatable(self).__copy(self)
		local mt = getmetatable(new)
		if mt.__new then mt.__new(new,...) end
		if mt.__init then mt.__init(new) end
		return new
	end
end )

return class:new()