local Font = require("Font")
local Button = require("Button")

local Story = Object:extend()

function Story:new(try)
	self.try = try
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
	return result
end

function Story:step(text, color)
	coroutine.yield({Button(text, Font(30, 2, 0.2), color, 0)})
end

function Story:choice(options)
	local buttons = {}
	for i, option in ipairs(options) do
		table.insert(buttons, Button(
			option,
			Font(30, 2, 0.2),
			{0, 1, 1},
			(i - #options / 2 - 0.5) * 50
		))
	end
	return coroutine.yield(buttons)
end

function Story:narrator(text)
	self:step(text, {1, 1, 1})
end

function Story:male(text)
	self:step(text, {0, 1, 1})
end

function Story:female(text)
	self:step(text, {1, 0, 1})
end

function Story:run()
	local choice
	
	self:narrator("Click me")
	self:narrator("She's pretty")
	self:narrator("Really pretty")
	self:narrator("You don't know her name")
	self:narrator("But you've already thought about everything")
	self:narrator("It's gonna be love at first sight")
	self:narrator("You're gonna be adorable together")
	self:narrator("And you're gonna marry after 3 years")
	self:narrator("And you're gonna have 2 and a half children")
	self:narrator("And they're names are gonna be Jack, Josh and Ju")
	self:narrator("And OH GOD SHE'S LOOKING AT YOU")
	
	choice = self:choice({
		"Hello",
		"You're really pretty",
		"How heavy is a polar bear?"
	})
	if choice == 1 then
		self:female("Hello?")
	elseif choice == 2 then
		self:female("Uh...")
		self:female("Thanks?")
		self:narrator("Did you really just say that?")
	elseif choice == 3 then
		self:female("What?")
		self:male("A polar bear")
		self:male("How heavy is it?")
		self:female("I... uh")
		self:female("Don't know")
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

	choice = self:choice({
		"I love games",
		"Nah I don't like games either",
		"Actually I've made a few games"
	})
	if choice == 1 then
		self:female("Oh neat, what sort?")
		self:male("Uh...")
		self:male("Dating sims")
		self:female("Oh")
		self:narrator("Oh?")
		self:female("...")
		self:narrator("Fuck")
		self:female("Each to their own I guess")
	elseif choice == 2 then
		self:narrator("You lied")
		self:narrator("But you know what they say")
		self:narrator("Opposites repel")
		self:narrator("Right?")
	elseif choice == 3 then
		self:female("Oh that's neat")
		self:female("Anything I would know?")
		self:male("Probably not")
	end
end

return Story