---@namespace HorseMod

local HorseManager = require("HorseMod/HorseManager")
local AnimationVariable = require("HorseMod/AnimationVariable")
local Stamina = require("HorseMod/Stamina")


---@enum Sound
local Sound = {
    IDLE = "HorseIdleSnort",
    STRESSED = "HorseStressed",
    EATING = "HorseEating",
    PAIN = "HorsePain",
    GALLOP_ROUGH = "HorseGallopConcrete",
    GALLOP_SOFT = "HorseGallopDirt",
    TROT_ROUGH = "HorseTrotConcrete",
    TROT_SOFT = "HorseTrotDirt",
    WALK_ROUGH = "HorseWalkConcrete",
    WALK_SOFT = "HorseWalkDirt",
    TIRED = "HorseGallopTired",
    MOUNT = "HorseMountSnort",
    DEATH = "HorseDeath"
}

---@class FootstepSounds
---@field rough Sound?
---@field soft Sound?

---@type table<MovementState, FootstepSounds>
local footsteps = {
    gallop = {
        rough = Sound.GALLOP_ROUGH,
        soft = Sound.GALLOP_SOFT
    },
    trot = {
        rough = Sound.TROT_ROUGH,
        soft = Sound.TROT_SOFT
    },
    walking = {
        rough = Sound.WALK_ROUGH,
        soft = Sound.WALK_SOFT
    },
    idle = {
        rough = nil,
        soft = nil
    }
}

---@readonly
local MIN_STRESS_FOR_SOUND = 70
---@readonly
local STRESS_INTERVAL_SECONDS = 15
---@readonly
local IDLE_INTERVAL_SECONDS = 60
---@readonly
local ATTRACTION_EVENT_INTERVAL_SECONDS = 4
---@readonly
local MAX_STAMINA_FOR_TIRED_SOUND = 30


---@class HorseSounds
---
---@field animal IsoAnimal
---
---Currently playing footstep sound
---@field footstepSound Sound?
---
---Handle of the currently playing footstep sound.
---@field footstepHandle integer
---
---Last emitter used to play a sound.
---@field lastEmitter BaseCharacterSoundEmitter?
---
---@field tiredSoundHandle integer
---
---@field variableCache table<AnimationVariable, boolean?>
---
---Seconds since last stressed sound to avoid spam.
---@field stressDebounce number
---
---Seconds since last idle sound to avoid spam.
---@field idleDebounce number
---
---Seconds since last attraction event.
---@field attractionEventTimer number
local HorseSounds = {}
HorseSounds.__index = HorseSounds


---@param emitter BaseCharacterSoundEmitter
---@param sound Sound
---@param volume number
---@return integer handle Handle of the played sound.
local function playOneShot(emitter, sound, volume)
    local handle = emitter:playSound(sound)
    emitter:setVolume(handle, volume)

    return handle
end



---@class SoundsSystem : System
local SoundsSystem = {}


---@type table<IsoAnimal, HorseSounds?>
SoundsSystem.horseSounds = {}


---@type number
SoundsSystem.volume = 1


---@param delta number
function HorseSounds:updateAttraction(delta)
    self.attractionEventTimer = self.attractionEventTimer + delta
    if self.attractionEventTimer >= ATTRACTION_EVENT_INTERVAL_SECONDS then
        -- TODO: radius and volume should depend on current movement
        addSound(
            self.animal,
            math.floor(self.animal:getX()),
            math.floor(self.animal:getY()),
            math.floor(self.animal:getZ()),
            4,
            4
        )
    end
end


---@param animal IsoAnimal
---@return boolean
---@nodiscard
local function shouldIdleSnort(animal)
    local moving = animal:isAnimalMoving()
    if moving then
        return false
    end
    if animal:getVariableBoolean(AnimationVariable.MOUNTING_HORSE) then
        return false
    end
    if animal:getVariableBoolean(AnimationVariable.RIDING_HORSE) then
        return false
    end
    if animal:getVariableBoolean(AnimationVariable.EATING) then
        return false
    end
    if animal:getVariableBoolean(AnimationVariable.HURT) then
        return false
    end

    return true
end


---@param delta number
function HorseSounds:updateIdleSounds(delta)
    if not shouldIdleSnort(self.animal) then
        return
    end

    self.idleDebounce = self.idleDebounce + delta
    if self.idleDebounce >= IDLE_INTERVAL_SECONDS then
        self.idleDebounce = self.idleDebounce % IDLE_INTERVAL_SECONDS
        playOneShot(self.animal:getEmitter(), Sound.IDLE, SoundsSystem.volume)
    end
end


---Plays a sound if an animation variable has become true since the last time the function was called for that variable.
---@param variable AnimationVariable
---@param sound Sound
---@param volume number
---@return integer handle Handle of the played sound. `-1` indicates no sound was played.
function HorseSounds:playSoundIfVariableBecameTrue(variable, sound, volume)
    local previousValue = self.variableCache[variable]    
    local value = self.animal:getVariableBoolean(variable)
    self.variableCache[variable] = value

    if not value or value == previousValue then
        return -1
    end

    return playOneShot(self.animal:getEmitter(), sound, volume)
end


---@param delta number
function HorseSounds:updateStressedSounds(delta)
    local stress = self.animal:getStress()
    if stress >= MIN_STRESS_FOR_SOUND then
        self.stressDebounce = self.stressDebounce + delta
        if self.stressDebounce >= STRESS_INTERVAL_SECONDS then
            self.stressDebounce = self.stressDebounce % STRESS_INTERVAL_SECONDS
            playOneShot(
                self.animal:getEmitter(),
                Sound.STRESSED,
                SoundsSystem.volume
            )
        end
    else
        self.stressDebounce = 0
    end
end


---@param animal IsoAnimal
---@return MovementState
---@nodiscard
local function getMovementState(animal)
    -- FIXME: this is basically a duplicate of MountController:getMovementState because we don't always have a Mount to check
    if not animal:isAnimalMoving() then
        return "idle"
    elseif animal:getVariableBoolean(AnimationVariable.GALLOP) then
        return "gallop"
    elseif animal:getVariableBoolean(AnimationVariable.TROT) then
        return "trot"
    else
        return "walking"
    end
end


---@type table<string, true?>
local ROUGH_MATERIALS = { Sand = true, Grass = true, Gravel = true, Dirt = true }


---@param square IsoGridSquare
---@return boolean
---@nodiscard
local function isSquareRough(square)
    local floor = square:getFloor()
    if floor then
        local material = floor:getProperty("FootstepMaterial")
        if ROUGH_MATERIALS[material] then
            return true
        end
    end

    ---@type IsoObject[]
    local objects = square:getLuaTileObjectList()
    for i = 0, #objects do
        local object = objects[i]
        local material = object:getProperty("FootstepMaterial")
        if ROUGH_MATERIALS[material] then
            return true
        end
    end

    return false
end


function HorseSounds:stopFootsteps()
    self.animal:getEmitter():stopSound(self.footstepHandle)
    self.footstepHandle = -1
end


function HorseSounds:updateFootsteps()
    local movementState = getMovementState(self.animal)
    local sound
    if isSquareRough(self.animal:getSquare()) then
        sound = footsteps[movementState].rough
    else
        sound = footsteps[movementState].soft
    end

    local emitter = self.animal:getEmitter()

    if sound ~= self.footstepSound then
        if self.footstepHandle ~= -1 then
            self:stopFootsteps()
        end

        if sound then
            self.footstepHandle = emitter:playSound(sound)
        end

        self.footstepSound = sound
    end

    if self.footstepHandle ~= 1 then
        emitter:setVolume(self.footstepHandle, SoundsSystem.volume)
    end
end


function HorseSounds:stopTiredSound()
    self.animal:getEmitter():stopSound(self.tiredSoundHandle)
end


function HorseSounds:updateTiredSound()
    local emitter = self.animal:getEmitter()
    if getMovementState(self.animal) == "gallop" and Stamina.get(self.animal) <= MAX_STAMINA_FOR_TIRED_SOUND then
        if self.tiredSoundHandle == -1 then
            self.tiredSoundHandle = emitter:playSound(Sound.TIRED)
        end
        emitter:setVolume(self.tiredSoundHandle, SoundsSystem.volume)
    elseif self.tiredSoundHandle ~= -1 then
        self:stopTiredSound()
    end
end


---@param delta number
function HorseSounds:update(delta)
    self:playSoundIfVariableBecameTrue(
        AnimationVariable.HURT,
        Sound.PAIN,
        SoundsSystem.volume
    )
    self:playSoundIfVariableBecameTrue(
        AnimationVariable.EATING,
        Sound.EATING,
        SoundsSystem.volume
    )

    self:updateFootsteps()
    self:updateTiredSound()
    self:updateStressedSounds(delta)
    self:updateIdleSounds(delta)            
    self:updateAttraction(delta)
end


function SoundsSystem:update(horses, delta)
    -- need to update this each tick incase the player changes their volume
    self.volume = getCore():getOptionSoundVolume() * 0.1

    for i = 1, #horses do
        local horse = horses[i]

        local soundData = SoundsSystem.horseSounds[horse]
        assert(soundData ~= nil, "SoundsSystem.update encountered a horse with no sound data")

        soundData:update(delta)
    end
end


table.insert(HorseManager.systems, SoundsSystem)


---@param animal IsoAnimal
local function createSoundData(animal)
    SoundsSystem.horseSounds[animal] = setmetatable(
        {
            animal = animal,
            footstepSound = nil,
            footstepHandle = -1,
            lastEmitter = nil,
            tiredSoundHandle = -1,
            variableCache = {},
            stressDebounce = 0,
            idleDebounce = 0,
            attractionEventTimer = 0
        },
        HorseSounds
    )
end

HorseManager.onHorseAdded:add(createSoundData)


---@param animal IsoAnimal
local function removeSoundData(animal)
    local soundData = SoundsSystem.horseSounds[animal]
    if not soundData then
        return
    end

    soundData:stopFootsteps()
    soundData:stopTiredSound()

    SoundsSystem.horseSounds[animal] = nil
end

HorseManager.onHorseRemoved:add(removeSoundData)


local HorseSounds = {}

HorseSounds.Sound = Sound


---@param animal IsoAnimal
---@param sound Sound
function HorseSounds.playSound(animal, sound)
    playOneShot(animal:getEmitter(), sound, SoundsSystem.volume)
end


return HorseSounds