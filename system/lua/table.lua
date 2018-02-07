local function str(v)
    if type(v) == "string" then
        return "\""..tostring(v):gsub("\n","\\n"):gsub("\"","\\\"").."\""
    end
    return tostring(v)
end

function table.format(self, s, tables)
    local s = s or ""
    if type(self) ~= "table" then return s..str(self) end
    local tables = tables or {}
    if tables[self] then
        if tables[tables[self]] then
            return s.."T"..tables[self]
        end
        tables[tables[self]] = self
    end
    local s = s.."{"
    for k , v in pairs(self) do
        if type(v) ~= "function" then
            if type(v) == "table" and not tables[v] then
                tables[v] = #tables + 1
                s = table.format(v , "local T"..tables[v].." = " , tables).."\n"..s
            end
            s = table.format(k , s.."[" , tables)
            s = table.format(v , s.."] = " , tables)..", "
        end
    end
    return s.."}"
end

function table.add(self, item, i, name)
    if type(i) == "string" then
        self[i] = item
        i = name
    end
    if name then
        self[name] = item
    end
    i = i or #self + 1
    if i < 0 then
        i = #self + 2 - i
    end
    table.insert(self,i,item)
    return item
end

function table.size(self)
    l = 0
    for k , v in pairs(self) do
        l = l + 1
    end
    return l
end

function table.clear(self)
    for k , v in pairs(self) do
        self[k] = nil
    end
end

function table.iclear(self)
    for k , v in ipairs(self) do
        self[k] = nil
    end
end

function table.overlay(self, new)
    for k , v in pairs(new) do
        self[k] = v
    end
end

function table.uptable(func)
    local value = {}
    local index = {}

    i = 1
    while true do
        local k, v = debug.getupvalue(func, i)
        if not k then break end
        value[k] = v
        index[k] = i
        i = i + 1
    end

    return setmetatable( {} , {
        __index = value,
        __pairs = value,
        __ipairs = value,
        __newindex = function(self,k,v)
            if index[k] then
                debug.setupvalue(func, index[k], v)
            else
                f = load( "function() end" ,"code","t",{k=v})
                debug.upvaluejoin(func, #index + 1, f, 1)
            end
            value[k] = v
            index[k] = v
        end
    } )
end