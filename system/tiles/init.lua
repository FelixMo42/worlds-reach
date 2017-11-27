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

system.tiles.globolize = function(t)
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

function system.tiles:save(data)
	if data.save then return data:save() end
	local s = "return system.tiles."..data.type..":new({"
	local t = {}
	for k , v in pairs(data) do
		if table.format( data[k] ) ~= table.format( system.tiles[data.type][k] ) then
			s = table.format(k , s.."[" , t)
			s = table.format(v , s.."] = " , t)..", "
		end
	end
	system.filesystem:write(data.type.."s/"..data.file..".lua" , s.."})")
	return s.."})"
end

function system.tiles:load(class)
	for i , n in ipairs(self:getDirectory(class,".lua")) do
		system.tiles[class][ #system.tiles[class] + 1 ] = loadstring( system.filesystem.read(class.."/"..n) )
		system.tiles[class][ system.tiles[class][ #system.tiles[class] ].name ] = system.tiles[class][ #system.tiles[class] ]
		system.tiles[class][ system.tiles[class][ #system.tiles[class] ].id ] = system.tiles[class][ #system.tiles[class] ]
		system.tiles[class][ system.tiles[class][ #system.tiles[class] ].file ] = system.tiles[class][ #system.tiles[class] ]
		system.tiles[class][ system.tiles[class][ #system.tiles[class] ] ] = system.tiles[class][ #system.tiles[class] ]
	end
end

function system.tiles:loadAll()
	local classes = {"skill","action","item","object","player","tile","map"}
	for i , c in pairs( classes ) do
		self:load( c )
	end
end