local Font = require("Font")
local Button = require("Button")

local Story = Object:extend()
Story.used = {}

function Story:new()
	self.try = 0
	self:create()
end

function Story:create()
	self.try = self.try + 1
	self.routine = coroutine.create(self.run)
	self.first = true
end

function Story:resume(arg)
	if self.first then
		arg = self
		self.first = false
	end

	local success, result = coroutine.resume(self.routine, arg)
	if not success then
		error(result)
	end
	if not result then
		self:create()
		return self:resume()
	end
	return result
end

function Story:step(text, color)
	coroutine.yield({Button(text, Font(30, 1, 0.2), color, 0)})
end

function Story:choice(options)
	local map = {}
	for i, option in ipairs(options) do
		if not Story.used[option] then
			table.insert(map, i)
		end
	end

	local buttons = {}
	local pos = 0
	for i, m in ipairs(map) do
		if not Story.used[option] then
			pos = pos + 1
			table.insert(buttons, Button(
				options[m],
				Font(30, 1, 0.2),
				{0.3, 0.5, 1.0},
				(i - #map / 2 - 0.5) * 50
			))
		end
	end
	
	local result = map[coroutine.yield(buttons)]
	Story.used[options[result]] = true
	return result
end

function Story:narrator(text)
	self:step(text, {1, 1, 1})
end

function Story:male(text)
	self:step(text, {0.3, 0.5, 1.0})
end

function Story:female(text)
	self:step(text, {1.0, 0.3, 0.5})
end

function Story:run()
	local choice
	local status = 0

	--[[
	self:narrator("Click me")
	self:narrator("She's pretty")
	self:narrator("Really pretty")
	self:narrator("You don't know her name")
	self:narrator("But you've already thought about everything")
	self:narrator("It's gonna be love at first sight")
	self:narrator("You're gonna be adorable together")
	self:narrator("And you're gonna marry after 3 years")
	self:narrator("And you're gonna have 2 and a half children")
	self:narrator("And OH GOD SHE'S LOOKING AT YOU")
	
	choice = self:choice({
		"Hello",
		"You're really pretty",
		"How heavy is a polar bear?"
	})
	if choice == 1 then
		status = status - 1
		self:female("Hello")
	elseif choice == 2 then
		status = status + 1
		self:female("Uh...")
		self:female("Thanks?")
		self:narrator("Did you really just say that?")
	elseif choice == 3 then
		self:female("What?")
		self:male("A polar bear")
		self:male("How heavy is it?")
		self:female("I... uh")
		self:female("Don't know?")
		self:male("Enough to break the ice")
		self:male("Hello, nice to meet you")
		self:female("Oh")
		self:female("Hello")
	end

	self:male("I'm guessing you're into games?")
	self:narrator("You were in an arcade after all")
	self:female("Actually not really")
	self:female("I just like to hang out here")
	self:female("What about you?")

	local dislike = false
	choice = self:choice({
		"I love games",
		"Nah I don't like games either",
		"Actually I've made a few games"
	})
	if choice == 1 then
		status = status - 1
		self:female("Oh neat, what sort?")
		self:male("Uh...")
		self:male("Dating sims")
		self:female("Oh")
		self:narrator("Oh?")
		self:female("...")
		self:narrator("Fuck")
		self:female("Each to their own I guess")
	elseif choice == 2 then
		status = status + 1
		dislike = true
		self:narrator("You lied")
		self:narrator("But you know what they say")
		self:narrator("Opposites repel")
		self:narrator("Right?")
	elseif choice == 3 then
		self:female("Oh that's neat")
		self:female("Anything I would know?")

		local title = love.window.getTitle()
		love.window.setTitle("Probably Not - The Game")
		self:male("Probably Not")
		love.window.setTitle(title)
	end

	self:female("Hey, I'm going to this party this weekend")
	self:female("Wanna come along?")
	
	if dislike then
		self:narrator("See told you")
	else
		self:narrator("Woah that was quick")
		self:narrator("How did that happen?")
		self:narrator("Doesn't matter")
	end

	choice = self:choice({
		"Sure",
		"Hell yeah",
		"Definitely"
	})
	if choice == 1 then
		status = status - 1
	elseif choice == 2 then
		status = status + 1
	end
	]]

	self:narrator("It was a chilly night")
	self:narrator("Warmed by a backyard fire")
	self:narrator("She...")
	self:narrator("She was beautiful")
	self:narrator("Of course")
	self:narrator("You...")
	self:narrator("You were trying your best")
	
	choice = self:choice({
		"Hello again",
		"That dress looks beautiful",
		"Nice place you've got here"
	})
	if choice == 1 then
		status = status - 1
		self:female("Welcome")
	elseif choice == 2 then
		status = status + 1
		self:female("Thank you")
		self:female("Your jumper looks...")
		self:female("Like a jumper")
		self:narrator("Ouch")
	elseif choice == 3 then
		self:female("Actually it's not my place")
		self:male("Oh ok")
	end

	self:female("Been up to much today?")
	
	choice = self:choice({
		"Playing video games",
		"Stressing over what I'm gonna say to you",
		"Not much"
	})
	if choice == 1 then
		status = status - 1
		if dislike then
			self:female("I thought you didn't like video games?")
			self:male("I don't")
		else
			self:female("Neat")
		end
	elseif choice == 2 then
		status = status + 1
		self:female("Oh")
		self:female("Figured it out yet?")
		self:male("Nope")
	elseif choice == 3 then
		self:female("Fair enough")
	end
end

return Story