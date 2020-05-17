
-- Fonts
local font = {}


-- Audio
local audio = {
  ["music"]   = la.newSource("assets/sounds/gamemusic.ogg", "stream"),
  ["boom"]    = la.newSource("assets/sounds/boom.ogg", "static"),
  ["toss"]    = la.newSource("assets/sounds/toss.ogg", "static"),
  ["jump"]    = la.newSource("assets/sounds/jump.ogg", "static"),
  ["splat"]   = la.newSource("assets/sounds/splat.ogg", "static"),
  ["success"] = la.newSource("assets/sounds/success.ogg", "static"),
  ["fail"]    = la.newSource("assets/sounds/fail.ogg", "static"),
}
audio.play = function(name, vol, loop)
  local source = audio[name]
  if vol then source:setVolume(vol) end
  if source:isPlaying() then source:stop() end
  source:play()
  if loop ~= nil then source:setLooping(loop) end
end
audio.clone = function(name)
  return audio[name]:clone()
end


-- Images
local image =  {
  ["dirtcover"] = lg.newImage("assets/dirtcover.png"),
}


-- Sprites
local tw          = 8
local spritesheet = lg.newImage("assets/spritesheet.png")
local iw, ih      = spritesheet:getDimensions()
local sprite      = {
  image     = spritesheet,
  grid      = Anim8.newGrid(tw, tw, iw, ih),
}
sprite.newQuad   = function(data)
  local frame, row = unpack(data)
  return sprite.grid(frame.."-"..frame, row)[1]
end
sprite.newAnimation = function(data)
  local frames, row, duration, onLoop = unpack(data)
  local grid = sprite.grid(frames, row)
  local anim = Anim8.newAnimation(grid, duration, onLoop):clone()
  return anim
end


-- Tileset
local tilesheet = lg.newImage("assets/tileset.png")
local iw, ih  = tilesheet:getDimensions()
local tileset = {
  image = tilesheet,
  grid  = Anim8.newGrid(tw, tw, iw, ih),
}
tileset.newAnimation = function(frames, row, durations, onLoop)
  local anim = Anim8.newAnimation(tileset.grid(frames, row), durations, onLoop):clone()
  return anim
end
tileset.getTile = function(id)
  if type(id) == "number" then
    return tileset.tiles[id]
  else
    for k=0, #tileset.tiles do
      local v = tileset.tiles[k]
      if v.name == string.lower(id) then return v end
    end
  end
end

-- Tiles
tileset.tiles = {
  [0] = {
    type = "tile",
    name = "back",
    pixelColor = {0, 0, 0},
    quad = lg.newQuad(tw*5, 0, tw, tw, iw, ih)},
  [1] = {
    type = "tile",
    name = "wall",
    pixelColor = {1, 0, 0},
    quad = lg.newQuad(tw*0, 0, tw, tw, iw, ih),
    collides = true,
    isSolid = true},
  [2] = {
    type = "tile",
    name = "top",
    pixelColor = {0, 1, 0},
    quad = lg.newQuad(tw*3, 0, tw, tw, iw, ih),
    collides = true,
    isSolid = true},
  [3] = {
    type = "tile",
    name = "grass",
    pixelColor = {0, 1, 1},
    anim = tileset.newAnimation('1-4', 4, .2),
    randomFrame = true},
  [4] = {
    type = "tile",
    name = "under",
    pixelColor = {1, 1, 0},
    quad = lg.newQuad(tw*2, 0, tw, tw, iw, ih),
    collides = true,
    isSolid = true},
  [5] = {
    type = "tile",
    name = "pillar",
    pixelColor = {128/255, 0, 128/255},
    quad = lg.newQuad(tw*1, 0, tw, tw, iw, ih)},
  [6] = {
    type = "tile",
    name = "drain",
    pixelColor = {128/255, 0, 0},
    anim = tileset.newAnimation('1-8', 2, .05),
    collides = true,
    isSolid = true},
  [7] = {
    type = "tile",
    name = "water",
    pixelColor = {0, 0, 128/255},
    anim = tileset.newAnimation('1-8', 3, .05)},
  [8] = {
    type = "entity",
    name = "exit",
    pixelColor = {1, 1, 1},
    quad = lg.newQuad(tw*5, 0, tw, tw, iw, ih)},
  [9] = {
    type = "entity",
    name = "player",
    pixelColor = {1, 0, 1},
    quad = lg.newQuad(tw*5, 0, tw, tw, iw, ih)},
  [10] = {
    type = "entity",
    name = "bug",
    pixelColor = {0, 0, 1},
    quad = lg.newQuad(tw*5, 0, tw, tw, iw, ih)},
}


return {
  font          = font,
  audio         = audio,
  image         = image,
  -- Spritesheet
  spritesheet   = spritesheet,
  newQuad       = sprite.newQuad,
  newAnimation  = sprite.newAnimation,
  -- Tileset
  tilesheet     = tilesheet,
  getTilesize   = function() return tw end,
  getTile       = tileset.getTile,
  getTiles      = function()return tileset.tiles end,
  -- Game cursor
  drawCursor    = function(cursor)
    local mx, my  = love.mouse.getPosition()
    local scale   = Screen.scale
    love.graphics.draw(sprite.image, cursor, mx-12, my-12, 0, scale, scale)
  end,
  drawDirtCover = function()
    love.graphics.setColor(1, 1, 1, .5)
    love.graphics.draw(image["dirtcover"])
    love.graphics.setColor(1, 1, 1, 1)
  end,
}
