return function(secs)
------------------------------------------------------------------- FUNDAMENTAL

secs:Component("camera", {
    target = false, 
    x1 = 0, 
    y1 = 0, 
    x2 = love.graphics.getWidth() / DEFAULT_WINDOW_SCALE, 
    y2 = love.graphics.getWidth() / DEFAULT_WINDOW_SCALE,
	width = love.graphics.getWidth() / DEFAULT_WINDOW_SCALE,
	height = love.graphics.getHeight() / DEFAULT_WINDOW_SCALE
})

secs:Component("stage", {
    map = false, 
    room = "1", 
    path = "",
})

secs:Component("roomEntity")

secs:Component("debug", {
    id = "", 
    message = "" 
})

secs:Component("spatialhash", {
    map = false
})

secs:Component("hitboxes", {})

----------------------------------------------------------------------- SPATIAL

secs:Component("pos", { 
    x = 0, 
    y = 0, 
    z = 0,
    width = 0,
    height = 0,
    dx = 1, 
    dy = 1
})

secs:Component("vel", { 
    x = 0, 
    y = 0, 
    maxX = 100, 
    maxY = 500, 
    defaultMaxX = 100, 
    defaultMaxY = 265
})

--------------------------------------------------------------------- RENDERING

secs:Component("sprite", {
    image = false
})

secs:Component("color", {
    rgb = { 255, 255, 255, 255 }
})

secs:Component("animation", {
    current = false,
    list = false,
})

------------------------------------------------------------------------- INPUT

secs:Component("playerInput", {
    queue = false, 
    commands = false
})

------------------------------------------------------------------- BEHAVIOURAL

secs:Component("playerState", { 
    ducking = false, 
    subweaponing = false, 
    jumping = false, 
    attacking = false, 
    walking = false, 
    dashing = false 
})

secs:Component("attackState", { 
    active = false, 
    finished = false, 
    timer = false, 
    type = "attack" 
})

secs:Component("physicsState", { 
    onGround = false, 
    hasGravity = true, 
    hasFriction = true
})

secs:Component("enemyState", { 
    behaviour = "attack", 
    state = "idle", 
    passiveDistance = 64
})

secs:Component("mortalState", { 
    health = 3, 
    dead = false, 
    invincible = false, 
    recovery = false
})

secs:Component("subweapon", {
    current = "knife", 
    ready = true, 
    recovery = 0.4, 
    stock = 5
})

secs:Component("isSubweapon", {
    type = "knife"
})

secs:Component("item", {
	value = false,
})

end