actions.endTurn.section = "tactical"
actions.endTurn.instant = true

actions.move.section = "tactical"

actions.fireBolt = action:new({
	id = "fireBolt", name = "fire bolt", section = "offencive",
	range = 5, Dmin = 1, Dmax = 5, height = 0
})