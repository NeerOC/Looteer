local Settings = require("src.settings")
local ItemManager = require("src.item_manager")
local Renderer = require("src.renderer")
local GUI = require("gui")

local function main_pulse()
    if not get_local_player() then return end

    Settings.update()

    if not Settings.get().enabled then return end

    if not Settings.should_execute() then return end

    local wanted_item = ItemManager.get_nearby_item()
    if wanted_item then
        interact_object(wanted_item)
    end
end

on_update(main_pulse)
on_render_menu(GUI.render)
on_render(Renderer.draw_stuff)