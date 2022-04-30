local Class = require "class"
local Collision = require "collision"
local Player = require "player"
local Bullet = require "bullet"
local TileMap = require "tilemap"

local Game = Class:inherit()

function Game:init()
	-- Global singletons
	collision = Collision:new()

	self.map = TileMap:new(60, 40)
	self.actors = {}
	self:new_actor(Player)
end

function Game:update(dt)
	self.map:update(dt)
	for k,actor in pairs(self.actors) do
		actor:update(dt)
	end
end

function Game:draw()
	self.map:draw()
	for k,actor in pairs(self.actors) do
		actor:draw()
	end

	local items, len = collision.world:getItems()
	for i,it in pairs(items) do
		local x,y,w,h = collision.world:getRect(it)
		love.graphics.setColor(0,1,0)
		love.graphics.rectangle("line", x, y, w, h)
	end
	-- Print FPS
	print_color(love.timer.getFPS(), 0, 0, COL_WHITE)
end

function Game:new_actor(actor, ...)
	table.insert(self.actors, actor:new(...))
end

return Game