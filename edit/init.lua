--[[
	Edit Mod v0.5 (Safer)
]]
local max_edit_range = 36

local function sign(x) -- different from math.sign never returns 0.
	if x > 0 then
		return 1
	elseif x < -0 then
		return -1
	end
	return 1
end

minetest.register_node("edit:fill",{
	description = "Fill",
	tiles = {"edit_fill.png"},
	inventory_image = "edit_fill.png",
	groups = {snappy = 2, oddly_breakable_by_hand = 3, not_in_creative_inventory=1},
	on_place = function(itemstack, placer, pointed_thing)
		if pointed_thing == nil or itemstack == nil or placer == nil or not minetest.is_player(placer) or placer:get_player_name() == nil or minetest.is_protected(pointed_thing.above, placer:get_player_name()) then return end

		if editmod_clipboard[placer:get_player_name()] ~= nil and editmod_clipboard[placer:get_player_name()].fillBlock1Pos then
			minetest.set_node(pointed_thing.above, {name = "edit:fill"})
			editmod_clipboard[placer:get_player_name()].fillBlock2Pos = pointed_thing.above

			if vector.distance(editmod_clipboard[placer:get_player_name()].fillBlock1Pos, editmod_clipboard[placer:get_player_name()].fillBlock2Pos) > max_edit_range then
				minetest.remove_node(editmod_clipboard[placer:get_player_name()].fillBlock1Pos)
				minetest.remove_node(editmod_clipboard[placer:get_player_name()].fillBlock2Pos)
				editmod_clipboard[placer:get_player_name()].fillBlock1Pos = nil;
				minetest.chat_send_player(placer:get_player_name(), "Too many blocks please select " .. max_edit_range .. " or less.");
				return nil;
			end
				
			local inv = minetest.get_inventory({type = "player", name = placer:get_player_name()})
			local formSpec = "size[8,6]label[0.5,0.5;Select the material you would like to use]button_exit[7,0;1,1;quit;X]"
			for y = 1, 4 do
				for x = 1, 8 do
					local name = inv:get_stack("main", ((y - 1) * 8) + x):get_name()
					formSpec
					=
					formSpec
					.. "item_image_button["
					.. (x - 1) .. ","
					.. (y + 1) .. ";1,1;"
					.. name .. ";"
					.. name .. ";]"
				end
			end
			minetest.show_formspec(placer:get_player_name(), "edit:pasteType", formSpec)
		else
			minetest.set_node(pointed_thing.above, {name = "edit:fill"})
			editmod_clipboard[placer:get_player_name()].fillBlock1Pos = pointed_thing.above
		end
	end,
	on_dig = function(pos, node, digger)
		if digger ~= nil and minetest.is_player(digger) then
			minetest.remove_node(pos);
			for name, value in pairs(editmod_clipboard) do
				if
					editmod_clipboard[name].fillBlock1Pos
					and editmod_clipboard[name].fillBlock1Pos.x == pos.x
					and editmod_clipboard[name].fillBlock1Pos.y == pos.y
					and editmod_clipboard[name].fillBlock1Pos.z == pos.z
				then
					editmod_clipboard[name].fillBlock1Pos = nil
					break
				elseif
					editmod_clipboard[name].fillBlock2Pos
					and editmod_clipboard[name].fillBlock2Pos.x == pos.x
					and editmod_clipboard[name].fillBlock2Pos.y == pos.y
					and editmod_clipboard[name].fillBlock2Pos.z == pos.z
				then
					editmod_clipboard[digger:get_player_name()].fillBlock2Pos = nil
					break
				end
			end
		end
	end
})
minetest.register_on_player_receive_fields(function(player, formname, fields)
	if player ~= nil and minetest.is_player(player) then
		if formname == "edit:pasteType" then
			for key, value in pairs(fields) do
				if
					editmod_clipboard[player:get_player_name()].fillBlock1Pos
					and editmod_clipboard[player:get_player_name()].fillBlock2Pos
				then
					local p1 = editmod_clipboard[player:get_player_name()].fillBlock1Pos
					local p2 = editmod_clipboard[player:get_player_name()].fillBlock2Pos

					if vector.distance(p1, p2) > max_edit_range then
						minetest.remove_node(p1)
						minetest.remove_node(p2)
						minetest.chat_send_player(player "Too many blocks please select " .. max_edit_range .. " or less.");
						return false;
					end

					if key == "quit" then
						minetest.remove_node(p1)
						minetest.remove_node(p2)
						editmod_clipboard[player:get_player_name()].fillBlock1Pos = nil
						editmod_clipboard[player:get_player_name()].fillBlock2Pos = nil
					else
						if key == "" then key = "air" end
						local def = minetest.registered_nodes[key]
						if not def then return end
						local param2
						if def.paramtype2 == "facedir" then
							param2 = minetest.dir_to_facedir(player:get_look_dir())
						elseif def.paramtype2 == "wallmounted" then
							param2 = minetest.dir_to_wallmounted(player:get_look_dir(), true)
						end
						--minetest.chat_send_all("" .. param2)
						for x = p1.x, p2.x, sign(p2.x - p1.x) do
							for y = p1.y, p2.y, sign(p2.y - p1.y) do
								for z = p1.z, p2.z, sign(p2.z - p1.z) do
									if not minetest.is_protected({x=x, y=y, z=z}, player:get_player_name()) then
										minetest.set_node({x = x, y = y, z = z}, {name = key, param2 = param2})
									end
								end
							end
						end
						minetest.close_formspec(player:get_player_name(), "edit:pasteType")
						editmod_clipboard[player:get_player_name()].fillBlock1Pos = nil
						editmod_clipboard[player:get_player_name()].fillBlock2Pos = nil
					end
				end
			end
			return true
		end
	end
    return false
end)

editmod_clipboard = {};
minetest.register_on_joinplayer(function(player)
	editmod_clipboard[player:get_player_name()] = {
		["fillBlock1Pos"] = nil,
		["fillBlock2Pos"] = nil,
		["copyData"] = {},
	};
end);
minetest.register_on_leaveplayer(function(player)
	editmod_clipboard[player:get_player_name()] = nil
end);
