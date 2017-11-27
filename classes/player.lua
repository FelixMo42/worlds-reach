function player:goto(x,y,f)
	local path = path:find(self.map , self.x,self.y , x,y)
	for i = 1 , #path do
		self.actions.move( path[i].x , path[i].y )
	end
	if f then f( x , y , f ) end
end