local Class = require "class"
local Actor = require "actor"
local Bullet = require "bullet"

local Player = Actor:inherit()

function Player:init(x,y)
	self:init_actor(x,y)

	self.x = x or 0
	self.y = y or 0

	self.w = 32
	self.h = 32

	self.dx = 0
	self.dy = 0

	self.is_dashing = false

	self.speed = 40
	self.friction = 0.9 -- This assumes that the game is running at 60FPS

	collision:add(self, self.x, self.y, self.w, self.h)
end

function Player:keypressed(key, scancode, isrepeat)
end

function Player:update(dt)
	self:move(dt)
	self:aim(dt)

	if love.mouse.isDown(1) then
		self.is_shoot = true
		game:new_actor(Bullet, self.x, self.y, self.dir)
	end
end

function Player:draw()
	love.graphics.setColor(1,0,0)
	love.graphics.rectangle("fill", self.x, self.y, 32, 32)
	love.graphics.setColor(1,1,1)
end

function Player:move(dt)
	-- compute movement dir
	local dir = {x=0, y=0}
	if love.keyboard.isScancodeDown('a') then   dir.x = dir.x - 1   end
	if love.keyboard.isScancodeDown('d') then   dir.x = dir.x + 1   end
	if love.keyboard.isScancodeDown('w') then   dir.y = dir.y - 1   end
	if love.keyboard.isScancodeDown('s') then   dir.y = dir.y + 1   end

	-- apply velocity 
	self.dx = self.dx + dir.x * self.speed 
	self.dy = self.dy + dir.y * self.speed 

	-- apply friction
	self.dx = self.dx * self.friction
	self.dy = self.dy * self.friction
	
	-- apply position
	local goal_x = self.x + self.dx * dt
	local goal_y = self.y + self.dy * dt

	local actual_x, actual_y, cols, len = collision:move(self, goal_x, goal_y)
	self.x = actual_x
	self.y = actual_y
end

function Player:aim(dt)
	local mx, my = love.mouse.getPosition()
	self.dir = math.atan2(mx - self.x, my - self.y)
end

return Player