local gui = require("gui")

local Settings = {}

local settings = {
    enabled = false,
    draw_wanted_items = false,
    quest_items = false,
    boss_items = false,
    rare_elixirs = false,
    skip_dropped = false,
    sigils = false,
    behavior = 0,
    rarity = 0,
    ga_count = 0,
    unique_ga_count = 0,
    uber_unique_ga_count = 0,
    distance = 2
}

function Settings.update()
    settings = {
        enabled = gui.elements.main_toggle:get(),
        draw_wanted_items = gui.elements.draw_wanted_toggle:get(),
        skip_dropped = gui.elements.skip_dropped_toggle:get(),
        quest_items = gui.elements.quest_items_toggle:get(),
        boss_items = gui.elements.boss_items_toggle:get(),
        rare_elixirs = gui.elements.elixir_items_toggle:get(),
        sigils = gui.elements.sigil_items_toggle:get(),
        behavior = gui.elements.behavior_combo:get(),
        rarity = gui.elements.rarity_combo:get(),
        ga_count = gui.elements.greater_affix_slider:get(),
        unique_ga_count = gui.elements.unique_greater_affix_slider:get(),
        uber_unique_ga_count = gui.elements.uber_unique_greater_affix_slider:get(),
        distance = gui.elements.distance_slider:get()
    }
end

function Settings.get()
    return settings
end

function Settings.should_execute()
    return settings.behavior == 0 or
        (settings.behavior == 1 and orbwalker.get_orb_mode() == orb_mode.clear)
end

return Settings
