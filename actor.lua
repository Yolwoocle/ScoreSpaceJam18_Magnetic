local Class = require "class"

local Actor = Class:inherit()

function Actor:init_actor(x,y)
	self.x = x or 0
	self.y = y or 0
end

function Actor:update()
	error("update not implemented")
end

function Actor:draw()
	error("draw not implemented")
end

return Actor