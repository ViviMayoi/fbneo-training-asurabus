assert(rb,"Run fbneo-training-mode.lua")

p1maxhealth = 0x78
p2maxhealth = 0x78

p1maxmeter = 0x40
p2maxmeter = 0x40

local p1health = 0x4862a9
local p2health = 0x4864a9

local p1prevhealth = rb(p1health)
local p2prevhealth = rb(p2health)

local p1meter = 0x48633b
local p2meter = 0x48653b

local p1combocounter = 0x486577
local p2combocounter = 0x486377

local p1direction = 0x484203
local p2direction = 0x484219

translationtable = {
	{
		"coin",
		"start",
		"select",
		"up",
		"down",
		"left",
		"right",
		"button1",
		"button2",
		"button3",
		"button4",
	},
	["Coin"] = 1,
	["Start"] = 2,
	["Select"] = 3,
	["Up"] = 4,
	["Down"] = 5,
	["Left"] = 6,
	["Right"] = 7,
	["Button 1"] = 8,
	["Button 2"] = 9,
	["Button 3"] = 10,
	["Button 4"] = 11,
}

function playerOneFacingLeft()
	return rb(p1direction)==1
end

function playerTwoFacingLeft()
	return rb(p2direction)==1
end

function playerOneInHitstun()
	return rb(p2combocounter)~=0
end

function playerTwoInHitstun()
	return rb(p1combocounter)~=0
end

function readPlayerOneHealth() -- delay by 1 frame to keep the combo counter in sync
	local ret = p1prevhealth
	p1prevhealth = rb(p1health)
	return ret
end

function writePlayerOneHealth(health)
	wb(p1health, health)
end

function readPlayerTwoHealth()
	local ret = p2prevhealth
	p2prevhealth = rb(p2health)
	return ret
end

function writePlayerTwoHealth(health)
	wb(p2health, health)
end

function readPlayerOneMeter()
	return rb(p1meter)
end

function writePlayerOneMeter(meter)
	wb(p1meter, meter)
end

function readPlayerTwoMeter()
	return rb(p2meter)
end

function writePlayerTwoMeter(meter)
	wb(p2meter, meter)
end

function infiniteTime()
	wb(0x48752d, 0x63)
end

function Run()
	infiniteTime()
end