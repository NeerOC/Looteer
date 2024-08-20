local Utils = {}

function Utils.distance_to(object)
   return get_player_position():dist_to_ignore_z(object:get_position())
end

function Utils.get_greater_affix_count(display_name)
   local count = 0
   for _ in display_name:gmatch("GreaterAffix") do
      count = count + 1
   end
   return count
end

function Utils.is_inventory_full()
   return get_local_player():get_item_count() == 33
end

function Utils.is_consumable_inventory_full()
   return get_local_player():get_consumable_count() == 33
end

return Utils
