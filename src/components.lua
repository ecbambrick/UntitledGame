--[[----------------------------------------------------------------------------
--]]----------------------------------------------------------------------------

------------------------------------------------------------------- FUNDAMENTAL

secs.component("camera", {
    target = false, 
    x1 = 0, 
    y1 = 0, 
    x2 = WINDOW_WIDTH, 
    y2 = WINDOW_HEIGHT
})

secs.component("stage", {
    map = false, 
    room = "1", 
    path = "", 
    loadStage = false, 
    loadRoom = false
})

secs.component("debug", {
    id = "", 
    message = "" 
})

secs.component("spatialhash", {
    map = false
})

secs.component("hitboxes", {})

----------------------------------------------------------------------- SPATIAL

secs.component("pos", { 
    x = 0, 
    y = 0, 
    z = 0,
    width = 0,
    height = 0,
    dx = 1, 
    dy = 1
})

secs.component("vel", { 
    x = 0, 
    y = 0, 
    maxX = 100, 
    maxY = 500, 
    defaultMaxX = 100, 
    defaultMaxY = 265
})

--------------------------------------------------------------------- RENDERING

secs.component("sprite", {
    image = false
})

secs.component("color", {
    rgb = { 255, 255, 255, 255 }
})

secs.component("animation", {
    current = false,
    list = false,
})

------------------------------------------------------------------------- INPUT

secs.component("playerInput", {
    queue = false, 
    commands = false
})

------------------------------------------------------------------- BEHAVIOURAL

secs.component("playerState", { 
    ducking = false, 
    subweaponing = false, 
    jumping = false, 
    attacking = false, 
    walking = false, 
    dashing = false 
})

secs.component("attackState", { 
    active = false, 
    finished = false, 
    timer = false, 
    type = "attack" 
})

secs.component("physicsState", { 
    onGround = false, 
    hasGravity = true, 
    hasFriction = true
})

secs.component("enemyState", { 
    behaviour = "attack", 
    state = "idle", 
    passiveDistance = 64
})

secs.component("mortalState", { 
    health = 3, 
    dead = false, 
    invincible = false, 
    recovery = false
})

secs.component("subweapon", {
    current = "knife", 
    ready = true, 
    recovery = 0.4, 
    stock = 5
})

secs.component("isSubweapon", {
    type = "knife"
})
