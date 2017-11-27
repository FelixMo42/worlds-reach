local path = {}

--local functions

local function add(l,t)
	l[t.x.."_"..t.y] = t
end

local function get(l,x,y)
	return l[x.."_"..y] or false
end

local function remove(l,x,y)
	l[x.."_"..y] = nil
end

local function calc(self, map, open, closed, x,y)
	if not get(closed , x , y) then return {} , closed , open end
	local path = { get(closed , x , y) }
	while path[#path].p do
		path[#path+1] = path[#path].p
	end
	local new = {}
	for i = #path - 1 , 1 , -1 do
		new[#path - i] = map[ path[i].x ][ path[i].y ]
	end
	if not self:open( map , x , y ) then
		new[#new] = nil
	end
	return new , closed , open
end

--functions

function path:open(map , x,y , mode)
	if not map[x] or not map[x][y] then return false end
	local mode = mode or {}

	if (mode.height or 0) == 2 then return true end
	if map[x][y].object and not map[x][y].object.walkable then return false end
	if map[x][y].player then return false end

	if (mode.height or 0) == 1 then return true end
	return map[x][y].walkable
end

function path:neighbours(map, node, tx,ty , mode)
	local n = {}
	for x = node.x - 1 , node.x + 1 do
		for y = node.y - 1 , node.y + 1 do
			if (x == tx and y == ty) or self:open(map,x,y,mode) then
				if (x == node.x and y ~= node.y) or (x ~= node.x and y == node.y) then
					n[#n + 1] = {x = x , y = y}
					n[#n].s = node.s + 10
					n[#n].e = math.dist(x,y , tx,ty)
					n[#n].t = n[#n].s + n[#n].e
					n[#n].p = node
				end
			end
		end
	end
	return n
end

function path:find(map, sx,sy , ex,ey , mode)
	--setup
	open , closed = {} , {}
	local current
	add(open , { x = sx , y = sy} )
	get(open , sx , sy).s = 0 --dist from start
	get(open , sx , sy).e = math.dist(sx,sy , ex,ey) --dist to end
	get(open , sx , sy).t = get(open , sx , sy).e --total dist
	--find path
	while true do
		--get current tile
		for pos , node in pairs(open) do
			if not current or current.t > node.t then
				current = node
			end
		end
		if not current then break end
		remove(open , current.x , current.y)
		add(closed , current)
		if get(closed , ex , ey) then break end
		--cheak neighbours
		local n = self:neighbours(map, current , ex , ey , mode)
		for i = 1 , #n do
			if not get(closed , n[i].x , n[i].y) then
				add(open , n[i])
			end
		end
		current = nil
	end
	return calc(self, map , open , closed , ex , ey)
end

function path:line(map, sx,sy , ex,ey , mode)
	if not map[ex] or not map[ex][ey] then return false , -1 , -1 , -1 , -1 end
	local mode = mode or {}
	local open = true
	local steps = math.max(math.abs(sx-ex),math.abs(sy-ey))
	local x, y, p = 0, 0, 0
	for step = 0 , steps do
		p = step / steps
		x = math.floor(sx * (1-p) + ex * p)
		y = math.floor(sy * (1-p) + ey * p)
		if x ~= sx or y ~= sy then
			if not mode.last and x == ex and y == ey then break end
			if not self:open(map,x,y,mode) then
				open = false
				break
			end
		end
	end
	return open , x , y , p , steps
end

return path