

-----------------------------------------------
--             Palm scanner                  --
-----------------------------------------------
-- /!\ When "overriding" a callback function --
-- re-use all the parameters in same order ! --
-----------------------------------------------

local has_mesecons = minetest.get_modpath("mesecons")


local function activate_palm_scanner(pos, node, player)
	local name = player and player:get_player_name()
	name = name or ""

	node.name = "scifi_nodes:palm_scanner_checking"
	minetest.swap_node(pos, node)

	minetest.sound_play("scifi_nodes_palm_scanner", {max_hear_distance = 8, pos = pos, gain = 1.0})
	minetest.chat_send_player(name, "Checking : please wait.")

	-- check protection
	minetest.after(2, function()
		if minetest.is_protected(pos, name or "") then
			-- clicker has no access to area
			minetest.chat_send_player(name, "Access denied !")
			minetest.sound_play("scifi_nodes_scanner_refused", {max_hear_distance = 8, pos = pos, gain = 1.0})

		else
			-- clicker can build here
			minetest.chat_send_player(name, "Access granted !")
			local rules = mesecon.rules.buttonlike_get(node)
			mesecon.receptor_on(pos, rules)

		end

		-- reset state
		minetest.after(5, function()
			node.name = "scifi_nodes:palm_scanner_off"
			minetest.swap_node(pos, node)
			local rules = mesecon.rules.buttonlike_get(node)
			mesecon.receptor_off(pos, rules)
		end)
	end)
end

minetest.register_node("scifi_nodes:palm_scanner_off", {
	description = "Palm scanner",
	tiles = {"scifi_nodes_palm_scanner_off.png",},
	inventory_image = "scifi_nodes_palm_scanner_off.png",
	wield_image = "scifi_nodes_palm_scanner_on.png",
	drawtype = "nodebox",
	sunlight_propagates = true,
	is_ground_content = false,
	legacy_wallmounted = true,
	walkable = false,
	buildable_to = false,
	on_rotate = mesecon.buttonlike_onrotate,
	selection_box = {
	type = "fixed",
		fixed = { -6/16, -6/16, 7/16, 6/16, 6/16, 8/16 }
	},
	node_box = {
		type = "fixed",
		fixed = {
		{ -6/16, -6/16, 7/16, 6/16, 6/16, 8/16 },	-- the thin plate behind the button
		--{ -4/16, -2/16, 4/16, 4/16, 2/16, 6/16 }	-- the button itself
	}
	},
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {
		cracky = 1,
		oddly_breakable_by_hand = 1,
		mesecon_needs_receiver = 1
	},
	mesecons = {receptor = {
		state = mesecon.state.off,
		rules = mesecon.rules.buttonlike_get
	}},
	on_rightclick = activate_palm_scanner,
	sounds = default.node_sound_glass_defaults(),
	on_blast = mesecon.on_blastnode,
})

minetest.register_node("scifi_nodes:palm_scanner_checking", {
	description = "Palm scanner",
	tiles = {{
		name = "scifi_nodes_palm_scanner_checking.png",
		animation = {type = "vertical_frames",aspect_w = 16,aspect_h = 16,length = 1.5}
	}},
	drawtype = "nodebox",
	selection_box = {
	type = "fixed",
		fixed = { -6/16, -6/16, 7/16, 6/16, 6/16, 8/16 }
	},
	node_box = {
		type = "fixed",
		fixed = {
		{ -6/16, -6/16, 7/16, 6/16, 6/16, 8/16 },	-- the thin plate behind the button
		--{ -4/16, -2/16, 4/16, 4/16, 2/16, 6/16 }	-- the button itself
	}
	},
	sunlight_propagates = true,
	paramtype = "light",
	paramtype2 = "facedir",
	is_ground_content = false,
	legacy_wallmounted = true,
	walkable = false,
	buildable_to = false,
	groups = {cracky=1, oddly_breakable_by_hand=1, not_in_creative_inventory=1, mesecon_needs_receiver = 1},
	drop = "scifi_nodes:palm_scanner_off",
	sounds = default.node_sound_glass_defaults()
})

minetest.register_node("scifi_nodes:palm_scanner_on", {
	drawtype = "nodebox",
	sunlight_propagates = true,
	paramtype = "light",
	paramtype2 = "facedir",
	is_ground_content = false,
	legacy_wallmounted = true,
	walkable = false,
	buildable_to = false,
	description = "Palm scanner",
	tiles = {"scifi_nodes_palm_scanner_on.png",},
	inventory_image = "scifi_nodes_palm_scanner_on.png",
	wield_image = "scifi_nodes_palm_scanner_on.png",
	selection_box = {
	type = "fixed",
		fixed = { -6/16, -6/16, 7/16, 6/16, 6/16, 8/16 }
	},
	node_box = {
		type = "fixed",
		fixed = {
		{ -6/16, -6/16, 7/16, 6/16, 6/16, 8/16 },	-- the thin plate behind the button
		--{ -4/16, -2/16, 4/16, 4/16, 2/16, 6/16 }	-- the button itself
	}
	},
	light_source = 5,
	groups = {cracky=1, oddly_breakable_by_hand=1, not_in_creative_inventory=1, mesecon_needs_receiver = 1},
	drop = "scifi_nodes:palm_scanner_off",
	mesecons = {receptor = {
		state = mesecon.state.on,
		rules = mesecon.rules.buttonlike_get
	}},
	sounds = default.node_sound_glass_defaults(),
	--on_rightclick = mesecon.button_turnoff,
	--on_timer = mesecon.button_turnoff,
})

minetest.register_craft({
	output = "scifi_nodes:palm_scanner_off 2",
	recipe = {{"mesecons_powerplant:power_plant", "scifi_nodes:grey", ""}}
})
