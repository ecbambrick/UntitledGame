--[[----------------------------------------------------------------------------
--]]----------------------------------------------------------------------------

------------------------------------------------------------------- FUNDAMENTAL

secs.type("cameras", "camera", "pos")
secs.type("spatialMaps", "spatialhash")

------------------------------------------------------------------------- INPUT

secs.type("controllablePlayers", "playerInput")

----------------------------------------------------------------------- PHYSICS

secs.type("physical", "pos", "vel")
secs.type("collidable", "hitboxes", "pos")

--------------------------------------------------------------------- RENDERING

secs.type("animated", "animation", "pos")
secs.type("sprites", "sprite", "pos")

---------------------------------------------------------------- INGAME OBJECTS

secs.type("players", "pos", "vel", "playerInput", "animation", "attackState", "playerState")
secs.type("stages", "stage")
secs.type("enemies", "pos", "enemyState")
secs.type("subweapons", "pos", "isSubweapon")
secs.type("roomEntities", "roomEntity")
