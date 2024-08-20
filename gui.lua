local plugin_label = "looteer"
local gui = {}
local options = require("data.gui_options")

gui.elements = {
   main_tree = tree_node:new(0),
   main_toggle = checkbox:new(false, get_hash(plugin_label .. "_main_toggle")),

   general = {
      tree = tree_node:new(1),
      behavior_combo = combo_box:new(0, get_hash(plugin_label .. "_behavior_combo")),
      rarity_combo = combo_box:new(0, get_hash(plugin_label .. "_rarity_combo")),
      distance_slider = slider_int:new(1, 30, 2, get_hash(plugin_label .. "_distance_slider")),
      skip_dropped_toggle = checkbox:new(false, get_hash(plugin_label .. "_skipped_dropped_toggle")),
   },

   affix_settings = {
      tree = tree_node:new(1),
      greater_affix_slider = slider_int:new(0, 3, 0, get_hash(plugin_label .. "_greater_affix_slider")),
      unique_greater_affix_slider = slider_int:new(0, 3, 0, get_hash(plugin_label .. "_unique_greater_affix_slider")),
      uber_unique_greater_affix_slider = slider_int:new(0, 3, 0,
         get_hash(plugin_label .. "_uber_unique_greater_affix_slider")),
   },

   item_types = {
      tree = tree_node:new(1),
      quest_items_toggle = checkbox:new(false, get_hash(plugin_label .. "_quest_items_toggle")),
      crafting_items_toggle = checkbox:new(false, get_hash(plugin_label .. "_crafting_items_toggle")),
      boss_items_toggle = checkbox:new(false, get_hash(plugin_label .. "_boss_items_toggle")),
      rare_elixir_items_toggle = checkbox:new(false, get_hash(plugin_label .. "_rare_elixir_items_toggle")),
      advanced_elixir_items_toggle = checkbox:new(false, get_hash(plugin_label .. "_advanced_elixir_items_toggle")),
      sigil_items_toggle = checkbox:new(false, get_hash(plugin_label .. "_sigil_items_toggle")),
   },

   debug = {
      tree = tree_node:new(1),
      draw_wanted_toggle = checkbox:new(false, get_hash(plugin_label .. "_draw_wanted_toggle")),
   },
}

function gui:render()
   if not gui.elements.main_tree:push("Looteer") then
      return
   end

   gui.elements.main_toggle:render("Enable", "Toggles the main module on/off")

   if not gui.elements.main_toggle:get() then
      gui.elements.main_tree:pop()
      return
   end

   if gui.elements.general.tree:push("General Settings") then
      gui.elements.general.behavior_combo:render("Behavior", options.behaviors,
         "When do you want the autolooter to execute?")
      gui.elements.general.rarity_combo:render("Rarity", options.rarities,
         "Minimum Rarity for bot to consider picking up.")
      gui.elements.general.distance_slider:render("Distance", "Distance from the loot to execute pickup")
      gui.elements.general.skip_dropped_toggle:render("Skip Self Dropped",
         "Do you want the bot to not loot items that you dropped yourself?")
      gui.elements.general.tree:pop()
   end

   if gui.elements.affix_settings.tree:push("Affix Settings") then
      gui.elements.affix_settings.greater_affix_slider:render("Legendary GA Count",
         "Minimum GA's to consider picking up legendary")
      gui.elements.affix_settings.unique_greater_affix_slider:render("Unique GA Count",
         "Minimum GA's to consider picking up unique")
      gui.elements.affix_settings.uber_unique_greater_affix_slider:render("Uber GA Count",
         "Minimum GA's to consider picking up Uber unique")
      gui.elements.affix_settings.tree:pop()
   end

   if gui.elements.item_types.tree:push("Item Types") then
      gui.elements.item_types.quest_items_toggle:render("Quest Items",
         "Do you want to pickup Quest items, this includes Objectives in dungeons.")
      gui.elements.item_types.crafting_items_toggle:render("Crafting Items", "Do you want to pickup Crafting Items?")
      gui.elements.item_types.boss_items_toggle:render("Boss Items", "Do you want to pickup Boss summon items?")
      gui.elements.item_types.rare_elixir_items_toggle:render("Rare Elixirs",
         "Do you wanna pickup Rare Elixirs? (Momentum, Holy Bolts)")
      gui.elements.item_types.advanced_elixir_items_toggle:render("Advanced Elixirs",
         "Do you wanna pickup Advanced Elixirs II?")
      gui.elements.item_types.sigil_items_toggle:render("Sigils", "Do you want to loot dungeon sigils?")
      gui.elements.item_types.tree:pop()
   end

   if gui.elements.debug.tree:push("Debug") then
      gui.elements.debug.draw_wanted_toggle:render("Draw Wanted",
         "Do you want to draw the items that the bot considers picking up? (Debug)")
      gui.elements.debug.tree:pop()
   end

   gui.elements.main_tree:pop()
end

return gui
