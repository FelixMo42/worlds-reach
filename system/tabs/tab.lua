local tab = class:new({
	type = "tab",
	layer = {}
})

local function add(self,item,i,name)
	if type(i) == "string" then
		self[i] = item
		i = name
	elseif name then
		self[name] = item
	end
	if i == -1 then
		i = #self + 2 - i
	else
		i = i or #self + 1
	end
	table.insert(self,i,item)
	return item
end

function tab:__init()
	self:addLayer("ui")
	self:addLayer("main")
	self.layer.main.tab = _G[self.name]
	function self.layer.main:dofunc(f,...)
		if self.tab[f] then
			return self.tab[f](...)
		end
	end
end

function tab:addLayer(name , i)
	self.layer[name] = {add = add}
	_G[self.name][name] = self.layer[name]
	i = i or #self.layer  + 1
	table.insert(self.layer,i,self.layer[name])
end

function tab:dofunc(f,...)
	local ret = {}
	revers = (f == "draw")
	for i = revers and #self.layer or 1 , revers and 1 or #self.layer , revers and -1 or 1 do
		local layer = self.layer[i]
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