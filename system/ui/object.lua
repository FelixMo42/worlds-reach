local object = class:new({
	type = "object",
	child = {active = true},
	width = 1, height = 1
})

function object:dofunc(f, ...)
	local function call(item,f,...)
		if item[f] ~= nil then
			if type(item[f]) == "function" then
				return item[f](item,...)
			elseif item[f].dofunc then
				return item[f].dofunc(item,...)
			else
				for i , v in ipairs(item[f]) do
					if type(v) == "function" then
						v(item,...)
					elseif type(v) == "string" and item[f][v] then
						item[f][v](item,...)
					end
				end
			end
		end
	end
	call(self,f,...)
	if self.child.active then
		for i , child in ipairs(self.child) do
			if rawtype(child) == "table" then
				if child.dofunc then
					child:dofunc(f,...)
				else
					call(child,f,...)
				end
			end
		end
	end
end

function object:addCallback(list, name, func, i)
	if not self[list] then self[list] = {} end
	i = i or #self[list] + 1
	self[list][name] = func
	table.insert(self[list],i,name)
end

function object:removeCallback(list, id)
	--to do
end

function object:addChild(c,i,n)
	if type(i) == "string" then
		self.child[i] = c
		i = n
	end
	i = i or #self.child + 1
	c.parent = self
	table.insert(self.child , i , c)
	return c
end

function object.child:is(var)
	local is = false
	for k , item in pairs(self) do
		if rawtype(item) == "table" then
			if item[var] then is = item[var] or is end
			if #(item.child or {}) > 0 and item.child.is then
				is = item[var] or item.child:is(var) or is
			end
		end
	end
	return is
end

function object.child:get(var)
	local vars = {}
	for k , item in pairs(self) do
		if item[var] then vars[#vars + 1] = item[var] end
	end
	return unpack(vars)
end

function object.child:clear(new)
	for k , v in pairs(self) do
		if rawtype(v) == "table" then self[k] = nil end
	end
end

return object