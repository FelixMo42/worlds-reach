system.update.include("lua")

system.settings.tiles.scale = system.settings.tiles.scale or 60
system.settings.tiles.line = system.settings.tiles.line or true
system.settings.tiles.clamp = system.settings.tiles.clamp or true
system.settings.tiles.speed = system.settings.tiles.speed or 5

system.tiles.path = require "system/tiles/path"
system.tiles.skill = require "system/tiles/skill"
system.tiles.action = require "system/tiles/action"
system.tiles.item = require "system/tiles/item"
system.tiles.object = require "system/tiles/object"
system.tiles.player = require "system/tiles/player"
system.tiles.tile = require "system/tiles/tile"
system.tiles.map = require "system/tiles/map"

function system.tiles:globolize()
	settings = system.settings
	path = system.tiles.path

	skill = system.tiles.skill
	action = system.tiles.action
	map = system.tiles.map
	player = system.tiles.player
	item = system.tiles.item
	object = system.tiles.object
	tile = system.tiles.tile

	skills = system.tiles.skills
	actions = system.tiles.actions
	maps = system.tiles.maps
	players = system.tiles.players
	items = system.tiles.items
	objects = system.tiles.objects
	tiles = system.tiles.tiles
end

function system.tiles:tostring(data, exceptions)
	local s = "system.tiles".."."..data.type
	local def
	if data.file then
		s = s.."s."..data.file..":new({"
		def = system.tiles[data.type.."s"][data.file]:new()
	else
		s = s..":new({"
		def = system.tiles[data.type]:new()
	end
	for k , v in pairs(data) do
		local c = exceptions and ( (exceptions[k] or exceptions.get or function() end)(data, k, v, def) )
		if c ~= nil then
			if c ~= "" and c ~= " "  then
				s = s..c..", "
			end
		else
			if table.format( data[k] ) ~= table.format( def[k] ) then
				s = table.format(k , s.."[")
				s = table.format(v , s.."] = ")..", "
			end
		end
	end
	return s.."})"
end

function system.tiles:format(data, exceptions)
	local s = "return system.tiles."..data.type..":new({"
	local def = system.tiles[data.type]:new()
	for k , v in pairs(data) do
		local c = exceptions and ( (exceptions[k] or exceptions.get or function() end)(data, k, v, def) )
		if c ~= nil then
			if c ~= "" and c ~= " "  then
				s = s..c..", "
			end
		elseif type( v ) ~= "function" then
			if table.format( data[k] ) ~= table.format( def[k] ) then
				s = table.format(k , s.."[")
				s = table.format(v , s.."] = ")..", "
			end
		end
	end
	return s.."})"
end

function system.tiles:save(data, exceptions)
	data.file = data.file or data.type:sub(1,1):upper()..(#system.filesystem:getDirectory("data/"..data.type.."s" , ".lua") + 1)
	local s = data.save and data:save(exceptions) or self:format(data, exceptions)
	system.filesystem:write("data/"..data.type.."s/"..data.file..".lua" , s)
	return s
end

function system.tiles:load(class)
	table.set( system.tiles[class] , {} )
	for i , file in ipairs( system.filesystem:getDirectory("data/"..class , ".lua") ) do
		self:addClass( loadstring( system.filesystem:read("data/"..class.."/"..file) )() )
	end
end

function system.tiles:loadAll()
	local classes = {"skills","items","objects","players","tiles","maps"} --add back actions eventualy
	for i , c in pairs( classes ) do
		self:load( c )
	end
end

function system.tiles:addClass(data)
	local class = data.type.."s"
	self[class][data] = data
	self[class][#self[class] + 1] = data
	if data.name then
		self[class][data.name] = data
	end
	if data.id then
		self[class][data.id] = data
	end
	if data.file then
		self[class][data.file] = data
	end
end