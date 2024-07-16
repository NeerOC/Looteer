local Settings = require("src.settings")
local Utils = require("utils.utils")
local CustomItems = require("data.custom_items")

local ItemManager = {}

function ItemManager.check_is_sigil(item)
    local item_info = item:get_item_info()
    if item_info:get_rarity() ~= 0 then return false end
    local name = item_info:get_skin_name()

    return name:find("Nightmare_Sigil")
end

function ItemManager.check_is_equipment(item)
    local item_info = item:get_item_info()
    if item_info:get_rarity() ~= 0 then return false end
    local name = item_info:get_skin_name()

    local equipment_names = { "Base", "Amulet", "Ring" }
    for _, word in ipairs(equipment_names) do
        if name:find(word) then
            return true
        end
    end
    return false
end

function ItemManager.check_is_quest_item(item)
    local item_info = item:get_item_info()
    if item_info:get_rarity() ~= 0 then return false end
    local name = item_info:get_skin_name()

    local quest_names = { "Global", "Glyph", "QST", "DGN", "pvp_currency" }
    for _, word in ipairs(quest_names) do
        if name:find(word) then
            return true
        end
    end
    return false
end

---@param ignore_distance boolean if we want to ignore the distance check
---@param item game.object Item to check
function ItemManager.check_want_item(item, ignore_distance)
    local item_info = item:get_item_info()
    if not item_info then return false end
    local id = item_info:get_sno_id()
    local rarity = item_info:get_rarity()
    local settings = Settings.get()
    local affixes = item_info:get_affixes()

    if Utils.distance_to(item) >= settings.distance and not ignore_distance then return false end

    if settings.skip_dropped and #affixes > 0 then
        return false
    end

    if settings.rarity == 0 and rarity == 0 and not ItemManager.check_is_equipment(item) then
        return false
    end

    if rarity < settings.rarity then
        if not (settings.boss_items and CustomItems.boss_items[id] or
                settings.quest_items and ItemManager.check_is_quest_item(item) or
                settings.rare_elixirs and CustomItems.elixirs[id] or
                settings.sigils and ItemManager.check_is_sigil(item)) then
            return false
        end
    end
    local is_special_item = settings.quest_items and ItemManager.check_is_quest_item(item) or
        settings.boss_items and CustomItems.boss_items[id] or
        settings.rare_elixirs and CustomItems.elixirs[id] or
        settings.sigils and ItemManager.check_is_sigil(item)
    if not is_special_item and Utils.is_inventory_full() then return false end
    if rarity >= 5 then
        local greater_affix_count = Utils.get_greater_affix_count(item_info:get_display_name())
        if (rarity == 5 and greater_affix_count < settings.ga_count) or
            (rarity == 6 and
                ((CustomItems.ubers[id] and greater_affix_count < settings.uber_unique_ga_count) or
                    (not CustomItems.ubers[id] and greater_affix_count < settings.unique_ga_count))) then
            return false
        end
    end
    return true
end

function ItemManager.get_nearby_item()
    local items = actors_manager:get_all_items()
    local fetched_items = {}

    for _, item in pairs(items) do
        if ItemManager.check_want_item(item, false) then
            table.insert(fetched_items, item)
        end
    end

    table.sort(fetched_items, function(x, y)
        return Utils.distance_to(x) < Utils.distance_to(y)
    end)

    return fetched_items[1]
end

return ItemManager
