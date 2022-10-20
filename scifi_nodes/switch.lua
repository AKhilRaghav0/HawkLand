
--------------
-- Switches --
--------------

local has_mesecons = minetest.get_modpath("mesecons")

local function toggle_switch(pos)
	local node = minetest.get_node(pos)
	local name = node.name
	if name == "scifi_nodes:switch_on" then
		minetest.sound_play("scifi_nodes_switch", {max_hear_distance = 8, pos = pos})
		minetest.set_node(pos, {name = "scifi_nodes:switch_off", param2 = node.param2})
		mesecon.receptor_off(pos, scifi_nodes.get_switch_rules(node.param2))
	elseif name == "scifi_nodes:switch_off" then
		minetest.sound_play("scifi_nodes_switch", {max_hear_distance = 8, pos = pos})
		minetest.set_node(pos, {name = "scifi_nodes:switch_on", param2 = node.param2})
		mesecon.receptor_on(pos, scifi_nodes.get_switch_rules(node.param2))
		minetest.get_node_timer(pos):start(2)
	end
end

mesecon.button_turnoff = function (pos)
	local node = minetest.get_node(pos)
	if node.name ~= "scifi_nodes:switch_on" then -- has been dug
		return
	end
	minetest.swap_node(pos, {name = "scifi_nodes:switch_off", param2 = node.param2})
	minetest.sound_play("mesecons_button_pop", { pos = pos }, true)
	local rules = mesecon.rules.buttonlike_get(node)
	mesecon.receptor_off(pos, rules)
end

minetest.register_node("scifi_nodes:switch_on", {
	description = "Wall switch",
	sunlight_propagates = true,
	buildable_to = false,
	tiles = {"scifi_nodes_switch_on.png",},
	inventory_image = "scifi_nodes_switch_on.png",
	wield_image = "scifi_nodes_switch_on.png",
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
	on_rotate = mesecon.buttonlike_onrotate,

	paramtype = "light",
	paramtype2 = "facedir",
	is_ground_content = false,
	legacy_wallmounted = true,
	light_source = 5,
	groups = {
		cracky=1,
		oddly_breakable_by_hand = 1,
		not_in_creative_inventory = 1,
		mesecon_needs_receiver = 1
	},
	mesecons = {receptor = {
		state = mesecon.state.on,
		rules = mesecon.rules.buttonlike_get
	}},
	--sounds = default.node_sound_glass_defaults(),
	on_rightclick = mesecon.button_turnoff,
	on_timer = mesecon.button_turnoff,
})

minetest.register_node("scifi_nodes:switch_off", {
	drawtype = "nodebox",
	tiles = {"scifi_nodes_switch_off.png",},
	inventory_image = "scifi_nodes_switch_on.png",
	wield_image = "scifi_nodes_switch_on.png",
	paramtype = "light",
	paramtype2 = "facedir",
	is_ground_content = false,
	legacy_wallmounted = true,
	walkable = false,
	buildable_to = false,
	on_rotate = mesecon.buttonlike_onrotate,
	sunlight_propagates = true,
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
	groups = {
		cracky = 1,
		oddly_breakable_by_hand = 1,
		mesecon_needs_receiver = 1
	},
	description = "Wall switch",
	on_rightclick = function (pos, node)
		minetest.swap_node(pos, {name = "scifi_nodes:switch_on", param2=node.param2})
		mesecon.receptor_on(pos, mesecon.rules.buttonlike_get(node))
		minetest.sound_play("mesecons_button_push", { pos = pos }, true)
		minetest.get_node_timer(pos):start(2)
	end,
	--sounds = default.node_sound_glass_defaults(),
	mesecons = {receptor = {
		state = mesecon.state.off,
		rules = mesecon.rules.buttonlike_get
	}},
	on_blast = mesecon.on_blastnode,
})

minetest.register_craft({
	output = "scifi_nodes:switch_off 2",
	recipe = {{"mesecons_button:button_off", "scifi_nodes:grey", ""}}
})
