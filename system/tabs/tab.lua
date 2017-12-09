local tab = class:new({
	type = "tab",
	layer = {}
})

function tab:__init()
	self:addLayer("ui")
	local layer = self:addLayer("main")
	layer.tab = _G[self.name]
	function layer:dofunc(f,...)
		if self.tab[f] then
			return self.tab[f](...)
		end
	end
end

function tab:addLayer(name , i)
	local layer = { add = table.add }
	_G[self.name][name] = layer
	local i = i or #self.layer  + 1
	table.insert(self.layer,i,name)
	return layer
end

function tab:dofunc(f,...)
	local ret , layer = {} , {}
	local revers = (f == "draw")
	for i = revers and #self.layer or 1 , revers and 1 or #self.layer , revers and -1 or 1 do
		if type( self.layer[i] ) == "string" then
			layer = _G[self.name][self.layer[i]]
		else
			layer = self.layer[i]
		end
		if layer.dofunc then
			ret[#ret + 1] = layer:dofunc(f,...)
		else
			for i , item in ipairs(layer) do
				if item.dofunc then
					ret[#ret + 1] = item:dofunc(f,...)
				elseif type(item[f]) == "function" then
					ret[#ret + 1] = item[f](item,...)
				end
			end
		end
	end
	return unpack(ret)
end

return tab