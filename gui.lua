local plugin_label = "autolooteer"
local gui = {}
local options = require("data.gui_options")

gui.elements = {
    main_tree = tree_node:new(0),
    main_toggle = checkbox:new(false, get_hash(plugin_label .. "_main_toggle")),
    behavior_combo = combo_box:new(0, get_hash(plugin_label .. "_behavior_combo")),
    rarity_combo = combo_box:new(0, get_hash(plugin_label .. "_rarity_combo")),
    choices_tree = tree_node:new(1),
    distance_slider = slider_int:new(1, 5, 2, get_hash(plugin_label .. "_distance_slider")),
    greater_affix_slider = slider_int:new(0, 3, 0, get_hash(plugin_label .. "_greater_affix_slider")),
    unique_greater_affix_slider = slider_int:new(0, 3, 0, get_hash(plugin_label .. "_unique_greater_affix_slider")),
    uber_unique_greater_affix_slider = slider_int:new(0, 3, 0,
        get_hash(plugin_label .. "_uber_unique_greater_affix_slider")),
    quest_items_toggle = checkbox:new(false, get_hash(plugin_label .. "_quest_items_toggle")),
    boss_items_toggle = checkbox:new(false, get_hash(plugin_label .. "_boss_items_toggle")),
    elixir_items_toggle = checkbox:new(false, get_hash(plugin_label .. "_elixir_items_toggle")),
    sigil_items_toggle = checkbox:new(false, get_hash(plugin_label .. "_sigil_items_toggle")),
    skip_dropped_toggle = checkbox:new(false, get_hash(plugin_label .. "_skipped_dropped_toggle")),
    draw_wanted_toggle = checkbox:new(false, get_hash(plugin_label .. "_draw_wanted_toggle")),
}

function gui:render()
    if not gui.elements.main_tree:push("Autolooteer") then
        return
    end

    gui.elements.main_toggle:render("Enable", "Toggles the main module on/off")
    -- Let's not continue rendering options when its disabled :D
    if not gui.elements.main_toggle:get() then
        gui.elements.main_tree:pop()
        return
    end

    gui.elements.skip_dropped_toggle:render("Skip Self Dropped",
        "Do you want the bot to not loot items that you dropped yourself?")
    gui.elements.behavior_combo:render("Behavior", options.behaviors, "When do you want the autolooter to execute?")
    gui.elements.rarity_combo:render("Rarity", options.rarities, "Minimum Rarity for bot to consider picking up.")

    if gui.elements.choices_tree:push("Settings") then
        gui.elements.distance_slider:render("Distance", "Distance from the loot to execute pickup")
        gui.elements.greater_affix_slider:render("Legendary GA Count", "Minimum GA's to consider picking up legendary")
        gui.elements.unique_greater_affix_slider:render("Unique GA Count", "Minimum GA's to consider picking up unique")
        gui.elements.uber_unique_greater_affix_slider:render("Uber GA Count",
            "Minimum GA's to consider picking up Uber unique")
        gui.elements.quest_items_toggle:render("Quest Items",
            "Do you want to pickup Quest items, this includes Objectives in dungeons.")
        gui.elements.boss_items_toggle:render("Boss Items", "Do you want to pickup Boss summon items?")
        gui.elements.elixir_items_toggle:render("Rare Elixirs",
            "Do you wanna pickup Rare Elixirs? (Momentum, Holy Bolts)")
        gui.elements.sigil_items_toggle:render("Sigils", "Do you want to loot dungeon sigils?")
        gui.elements.draw_wanted_toggle:render("Draw Wanted",
            "Do you want to draw the items that the bot considers picking up? (Debug)")
        gui.elements.choices_tree:pop()
    end

    gui.elements.main_tree:pop()
end

return gui
