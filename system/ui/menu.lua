local menu = system.ui.button:new({
	type = "menu"
})

menu.child.active = false

menu:addCallback("mousereleased","open",function(self)
	self.child.active = self.over or self.child:is("over")
end)

return menu