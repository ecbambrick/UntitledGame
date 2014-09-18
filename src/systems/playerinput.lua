local InputCommand      = require('lib.inputcommand')
local PlayerInputSystem = {}

--------------------------------------------------------------------------------
-- The player input system checks for player input and generates actions based
-- on those inputs
--
-- Uses the following components:
--  * playerInput
--  * actions
--------------------------------------------------------------------------------
function PlayerInputSystem:update(dt)
    local ecs               = self.ecs
    local attackButton      = self.attackButton
    local dropButton        = self.dropButton
    local jumpButton        = self.jumpButton
    local leftButton        = self.leftButton
    local rightButton       = self.rightButton
    local subweaponButton   = self.subweaponButton
    
    for entity in pairs(self.ecs:query("playerInput actions")) do
        local actions = entity.actions
        
        -- Check for input.
        attackButton:update(dt)
        dropButton:update(dt)
        jumpButton:update(dt)
        leftButton:update(dt)
        rightButton:update(dt)
        subweaponButton:update(dt)
        
        -- Check for movement. For each direction, if an opposing direction is 
        -- pressed, it will stop checking for double-presses. This is to prevent
        -- left->right->left from triggering leftButton:doublePress().
        if leftButton:doublePressed() then
            actions.dashLeft = true
            rightButton:cancelDoublePress()
        elseif leftButton:isDown() then
            actions.left = true
            rightButton:cancelDoublePress()
        end
        
        if rightButton:doublePressed() then
            actions.dashRight = true
            leftButton:cancelDoublePress()
        elseif rightButton:isDown() then
            actions.right = true
            leftButton:cancelDoublePress()
        end
        
        -- Check for dropping down one-way floors.
        if dropButton:pressed() then
            actions.drop = true
        
        -- Check for jumping.
        elseif jumpButton:pressed() then
            actions.jump = true
        elseif jumpButton:isDown() then
            actions.keepJumping = true
        end
        
        -- Check for attacks.
        if subweaponButton:pressed() then
            actions.subweapon = true
        elseif attackButton:pressed() then
            actions.attack = true
        end
        
        -- If the attack command is held, the player changes to a ready stance.
        if attackButton:isDown() and not attackButton:pressed() then
            actions.ready = true
        end
        
    end
end

--------------------------------------------------------------------------------
-- Constructs a new instance of the player input system.
-- @return a new instance of the player input system.
--------------------------------------------------------------------------------
return function(ecs)
    local self = {}
    
    -- The entity component system.
    self.ecs = ecs
    
    -- The input button for attacking.
    self.attackButton = InputCommand("x")
    
    -- The input button for dropping through one-way floors.
    self.dropButton = InputCommand("down", "z")
    
    -- The input button for jumping.
    self.jumpButton = InputCommand("z")
    
    -- The input button for moving left or dashing left.
    self.leftButton = InputCommand("left")
    
    -- The input button for moving right or dashing right.
    self.rightButton = InputCommand("right")
    
    -- The input button for using subweapons.
    self.subweaponButton = InputCommand("up", "x")
    
    return setmetatable(self, { __index = PlayerInputSystem })
end