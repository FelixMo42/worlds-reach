--love functions

_FUNCTIONS = {
	"draw",
	"update",
	"keypressed",
	"keyreleased",
	"textinput",
	"mousemoved",
	"mousepressed",
	"mousereleased",
	"wheelmoved",
	"mousefocus",
	"visible",
	"directorydropped",
	"filedropped",
	"resize",
	"load",
	"quit"
}

local function lovefunction(f)
	return function(...)
		for name , system in pairs(system.systems) do
			if system.dofunc then system:dofunc(f,...) elseif system[f] then system[f](system,...) end
		end
		system.tabs.current:dofunc(f,...)
		for name , system in pairs(system.systems) do
			if system.dofunc then system:dofunc(f.."End",...) elseif system[f.."End"] then system[f.."End"](system,...) end
		end
	end
end

function love.open(t,...)
	system.tabs.current:dofunc("close",...)
	if type(t) == "tab" then
		system.tabs.current = t
	elseif system.tabs[t] then
		system.tabs.current = system.tabs[t]
	else
		love.errhand( tostring(t).." is not a tab")
		return false
	end
	system.tabs.current:dofunc("open",...)
end

function love.load(...)
	system.tabs.current:dofunc("open",...)
	for name , system in pairs(system.systems) do
		if system.dofunc then
			system:dofunc("load",...)
		elseif system.load then
			system:load(...)
		end
	end
end

function love.quit(...)
	system.tabs.current:dofunc("close",...)
	for i , t in ipairs(system.tabs) do
		t:dofunc("quit",...)
	end
	for name , system in pairs(system.systems) do
		if system.dofunc then
			system:dofunc("quit",...)
		elseif system.quit then
			system:quit(...)
		end
	end
end

for i , f in ipairs(_FUNCTIONS) do
	love[f] = love[f] or lovefunction(f)
end

--systems

system.mouse = {
	x = love.mouse.getX(), y = love.mouse.getY(),
	dx = 0, dy = 0, sx = 0, sy = 0, ex = 0, ey = 0,
	button = 0, drag = false, used = false, down = false,
	mousemoved = function(self,x,y,dx,dy)
		system.mouse.dx , system.mouse.dy = dx , dy
		system.mouse.x , system.mouse.y = x , y
		if system.mouse.drag == false then
			system.mouse.drag = true
		end
		system.mouse.ex , system.mouse.ey = system.mouse.x , system.mouse.y
		if system.mouse.drag == nil then
			system.mouse.sx , system.mouse.sy = system.mouse.x , system.mouse.y
		end
	end,
	mousepressed = function(self,x,y,button)
		system.mouse.used = false
		system.mouse.drag = false
		system.mouse.down = true
		system.mouse.button = button
		system.mouse.sx = system.mouse.x
		system.mouse.sy = system.mouse.y
	end,
	mousereleased = function(self)
		system.mouse.down = false
		system.mouse.used = false
	end,
	mousereleasedEnd = function(self)
		system.mouse.drag = nil
		system.mouse.sx = system.mouse.x
		system.mouse.sy = system.mouse.y
	end
}

system.screen = {
	width = love.graphics.getWidth(),
	height = love.graphics.getHeight(),
	resize = function(self,w,h)
		system.screen.width = w
		system.screen.height = h
	end
}

system.systems = { system.mouse , system.screen }

--load files

system.load["tabs"] = function()
	for i , f in ipairs({"library","_library","classes","_classes"}) do
		if system.filesystem:exist(f) then
			if system.filesystem:exist(f.."/init.lua") then
				require(f)
			else
				for i , file in pairs( system.filesystem:getDirectory(f,".lua") ) do
					if not system.filesystem:isDirectory(f.."/"..file) then
						require(f.."/"..file:gsub(".lua",""))
					end
				end
			end
		end
	end

	--tabs

	for i , f in ipairs({"tabs","_tabs"}) do
		if system.filesystem:exist(f) then
			if system.filesystem:exist(f.."/init.lua") then
				require(f)
			else
				for i , file in pairs( system.filesystem:getDirectory(f,".lua") ) do
					if not system.filesystem:isDirectory(f.."/"..file) then
						file = file:gsub(".lua","")
						_G[file] = {}
						local tab = system.tab:new({name = file})
						_G[file].tab = tab
						system.tabs[#system.tabs + 1] = tab
						system.tabs[tab] = tab
						system.tabs[file] = tab
						system.tabs[ _G[file] ] = tab
						require(f.."/"..file)
						tab:dofunc("load")
					end
				end
			end
		end
	end

	if not system.tabs.current then
		system.tabs.current = system.tabs.def or system.tabs.menu or system.tabs[1] or system.console:new()
	end
end