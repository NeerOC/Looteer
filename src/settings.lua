local gui = require("gui")

local Settings = {}

local settings = {
   enabled = false,
   behavior = 0,
   rarity = 0,
   distance = 2,
   skip_dropped = false,
   ga_count = 0,
   unique_ga_count = 0,
   uber_unique_ga_count = 0,
   quest_items = false,
   crafting_items = false,
   boss_items = false,
   rare_elixirs = false,
   advanced_elixirs = false,
   sigils = false,
   draw_wanted_items = false
}

function Settings.update()
   settings = {
      enabled = gui.elements.main_toggle:get(),

      -- General Settings
      behavior = gui.elements.general.behavior_combo:get(),
      rarity = gui.elements.general.rarity_combo:get(),
      distance = gui.elements.general.distance_slider:get(),
      skip_dropped = gui.elements.general.skip_dropped_toggle:get(),

      -- Affix Settings
      ga_count = gui.elements.affix_settings.greater_affix_slider:get(),
      unique_ga_count = gui.elements.affix_settings.unique_greater_affix_slider:get(),
      uber_unique_ga_count = gui.elements.affix_settings.uber_unique_greater_affix_slider:get(),

      -- Item Types
      quest_items = gui.elements.item_types.quest_items_toggle:get(),
      crafting_items = gui.elements.item_types.crafting_items_toggle:get(),
      boss_items = gui.elements.item_types.boss_items_toggle:get(),
      rare_elixirs = gui.elements.item_types.rare_elixir_items_toggle:get(),
      advanced_elixirs = gui.elements.item_types.advanced_elixir_items_toggle:get(),
      sigils = gui.elements.item_types.sigil_items_toggle:get(),

      -- Debug
      draw_wanted_items = gui.elements.debug.draw_wanted_toggle:get()
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
