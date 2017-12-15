require "system/setup"

class = require "system/class"

--set up

system.settings = setmetatable( {} , getmetatable( system ) )
if love.conf then love.conf(system.settings) end

if system.settings.update.default or system.settings.update.default == nil then
	system.update.include("lua")
	
	system.update.globalize("filesystem")
	system.update.globalize("settings")

	system.update.include("ui")
	system.update.globalize("ui")
	
	color = ui.color
	font = ui.font

	system.update.include("tabs")
	system.update.globalize("tabs")

	system.update.globalize("screen")
	system.update.globalize("mouse")
end

for i , lib in pairs(system.settings.update.includes or {}) do
	system.update.include(lib)
end

--load

setmetatable( system.load , {
	__call = function()
		local mt = getmetatable( system.load )
		if not mt.__called then
			for k , v in pairs( system.load ) do
				v(k,v)
			end
		end
	end,
	__called = false
} )

if system.filesystem:exist("setup.lua") then
	require "setup"
end

system.load()