require "expression"
require "character"
require "state"
require "gamestate"
require "grid"
require "mainmenustate"
require "optionmenustate"
require "button"

math.randomseed(os.time()) --Initialize the RNG with a new seed
math.random()

function love.load() --Load all game assets
	love.graphics.setFont(12)
	--Store common colours in a table
	color =	 {	background = {0,0,0},
				main = {63,193,245},
				text = {255,255,255}}
	--Store all images in a table
	graphics = {sky = love.graphics.newImage("media/Sky.png"),
				characterLeft = love.graphics.newImage("media/soldierLeft.png"),
				characterRight = love.graphics.newImage("media/soldierRight.png"),
				landTexture = love.graphics.newImage("media/LandTex.png"),
				landBackTexture = love.graphics.newImage("media/LandBackTex.png"),
				logo = love.graphics.newImage("media/Logo.png")}
	--Store all font sizes in a table
	font = {	default = love.graphics.newFont(24),
				large = love.graphics.newFont(32),
				huge = love.graphics.newFont(72),
				small = love.graphics.newFont(22) }
	--Store all music files in a table
	music =	{	gameMusic = love.audio.newSource("media/GameMusic.mp3"), menuIntro = love.audio.newSource("media/MenuIntro.wav") }
	--Store all sounds in a table
	sounds = {	deathSounds = {love.audio.newSource("media/Death1.wav"), love.audio.newSource("media/Death2.wav")},
				tauntSounds = {love.audio.newSource("media/Taunt1.wav"), love.audio.newSource("media/Taunt2.wav")}}
	--Store all file paths in a table
	files = {names = "names.txt", adjectives = "adjectives.txt"}
	randomNames = {}
	randomAdjectives = {}
	numberOfPlayers = {1, 1} --1 player on each team
	screenLines = {}
	loadPlayerNames()
	state = MainMenuState:new() --Enter the main menu state
end

function love.draw() --Call the current states drawing function
	state:draw()
end

function love.update(dt) --Call the current states update function
	state:update(dt)end

function love.mousepressed(x, y, button) --Passes the mouse position and button status to the current state
	state:mousepressed(x, y, button)
end

function love.keypressed(key, unicode) --Passes keyboard status to the current state
	if key == "f4" and (love.keyboard.isDown("ralt") or love.keyboard.isDown("lalt")) then
		love.event.push("q")
	end
	state:keypressed(key, unicode)
end

function love.keyreleased( key, unicode ) --Passes keyboard status to the current state
	state:keyreleased( key, unicode )
end

function love.mousereleased( x, y, button ) --Passes the mouse position and button status to the current state
	state:mousereleased( x, y, button )
end

function loadPlayerNames() --Loads all names and adjectives from a file and stores them
	for line in love.filesystem.lines (files["names"]) do
	  table.insert (randomNames, line)
	end
	for line in love.filesystem.lines (files["adjectives"]) do
	  table.insert (randomAdjectives, line)
	end
end