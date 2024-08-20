local Settings = require("src.settings")
local ItemManager = require("src.item_manager")
local Utils = require("utils.utils")

local Renderer = {}

function Renderer.draw_stuff()
    if not get_local_player() or not Settings.get().enabled then return end

    if Utils.is_inventory_full() then
        graphics.text_3d("Inventory Full", get_player_position(), 20, color_red(255))
    end

    if Utils.is_consumable_inventory_full() then
        local ppos = get_player_position()
        local px, py, pz = ppos:x(), ppos:y(), ppos:z() + 1
        local new_ppos = vec3:new(px, py, pz)

        graphics.text_3d("Consumable Inventory Full", new_ppos, 20, color_red(255))
    end

    if not Settings.get().draw_wanted_items then return end

    local items = actors_manager:get_all_items()
    for _, item in pairs(items) do
        if ItemManager.check_want_item(item, true) then
            graphics.circle_3d(item:get_position(), 0.5, color_pink(255), 3)
        end
    end
end

return Renderer
