local gui = require("gui")
local data = require("data")

local settings = {
    enabled = false,
    draw_wanted_items = false,
    quest_items = false,
    boss_items = false,
    rare_elixirs = false,
    behavior = 0,
    rarity = 0,
    ga_count = 0,
    unique_ga_count = 0,
    distance = 2
}

local function update_settings()
    settings = {
        enabled = gui.elements.main_toggle:get(),
        draw_wanted_items = gui.elements.draw_wanted_toggle:get(),
        quest_items = gui.elements.quest_items_toggle:get(),
        boss_items = gui.elements.boss_items_toggle:get(),
        rare_elixirs = gui.elements.elixir_items_toggle:get(),
        behavior = gui.elements.behavior_combo:get(),
        rarity = gui.elements.rarity_combo:get(),
        ga_count = gui.elements.greater_affix_slider:get(),
        unique_ga_count = gui.elements.unique_greater_affix_slider:get(),
        distance = gui.elements.distance_slider:get()
    }
end

---@param object game.object
local function distance_to(object)
    return get_player_position():dist_to_ignore_z(object:get_position())
end

---@param display_name string
local function get_greater_affix_count(display_name)
    local count = 0
    for _ in display_name:gmatch("GreaterAffix") do
        count = count + 1
    end

    return count
end

local function is_inventory_full()
    return get_local_player():get_item_count() == 33
end

---@param item game.object
local function check_is_quest_item(item)
    local item_info = item:get_item_info()
    local rarity = item_info:get_rarity()
    local name = item_info:get_skin_name()


    return rarity == 0 and name:match("Global")
end

---@param item game.object
local function check_want_item(item)
    local item_info = item:get_item_info()

    if not item_info then
        return false
    end

    local id = item_info:get_sno_id()
    local is_boss_item = settings.boss_items and data.custom_items.boss_items[id]
    local rarity = item_info:get_rarity()
    local is_quest_item = settings.quest_items and check_is_quest_item(item)
    local is_rare_elixir = settings.rare_elixirs and data.custom_items.elixirs[id]
    local greater_affix_count = get_greater_affix_count(item_info:get_display_name())
    local within_distance = distance_to(item) < settings.distance
    local good_legendary = rarity == 5 and greater_affix_count >= settings.ga_count
    local good_unique = rarity == 6 and greater_affix_count >= settings.unique_ga_count
    local need_inventory_slot = not is_quest_item and not is_boss_item and not is_rare_elixir

    if need_inventory_slot and is_inventory_full() then
        return
    end

    -- if we are within distance of the item (setting) and the rarity is better than what we set in the combo box (setting)
    if within_distance and (rarity >= settings.rarity or is_boss_item or is_quest_item or is_rare_elixir) then
        -- if rarity is less than legendary or check legendary ga count or check unique ga count
        if rarity < 5 or (good_legendary or good_unique) then
            return true
        end
    end
end

---@return game.object
local function get_nearby_item()
    local items = actors_manager:get_all_items()
    local fetched_items = {}

    for _, item in pairs(items) do
        if check_want_item(item) then
            table.insert(fetched_items, item)
        end
    end

    table.sort(fetched_items, function(x, y)
        return distance_to(x) < distance_to(y)
    end)

    return fetched_items[1]
end

local function main_pulse()
    update_settings()

    if not settings.enabled then
        return
    end

    -- Let's check for the combo box option if we want to continue or not (Behavior)
    local should_execute = settings.behavior == 0 or
        settings.behavior == 1 and orbwalker.get_orb_mode() == orb_mode.clear
    if not should_execute then
        return
    end

    local wanted_item = get_nearby_item()
    if wanted_item then
        interact_object(wanted_item)
    end
end

local function draw_stuff()
    if is_inventory_full() then
        graphics.text_3d("Inventory Full", get_player_position(), 20, color_red(255))
    end

    if not settings.draw_wanted_items then
        return
    end

    local items = actors_manager:get_all_items()
    for _, item in pairs(items) do
        local want_item = check_want_item(item)

        if want_item then
            graphics.circle_3d(item:get_position(), 0.5, color_pink(255), 1)
        end
    end
end

on_update(main_pulse)
on_render_menu(gui.render)
on_render(draw_stuff)
