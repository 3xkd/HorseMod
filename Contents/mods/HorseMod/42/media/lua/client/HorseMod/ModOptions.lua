local config = {
    horseSoundVolume = nil,
    horseWalkSpeed = nil,
    horseTrotSpeed = nil,
    horseGallopSpeed = nil,
    horseJumpButton = nil
}


-- TODO: use translation strings for this
local function HorseConfig()
    local options = PZAPI.ModOptions:create("HorseMod", getText("IGUI_ModOptions_HorseModName"))

    options:addDescription(getText("IGUI_ModOptions_HorseSoundVolumeDesc"))
    config.horseSoundVolume = options:addSlider("HorseSoundVolume", getText("IGUI_ModOptions_HorseSoundVolumeName"), 0.01, 1, 0.01, 0.40, getText("IGUI_ModOptions_HorseSoundVolumeTooltip"))

    options:addDescription(getText("IGUI_ModOptions_HorseKeybind"))
    config.horseJumpButton = options:addKeyBind("HorseJumpButton", getText("IGUI_ModOptions_HorseKeybindJumpName"), Keyboard.KEY_SPACE, getText("IGUI_ModOptions_HorseKeybindJumpTooltip"))
end

HorseConfig()
