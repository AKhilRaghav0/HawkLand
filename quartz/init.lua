-- local settings = Settings(minetest.get_modpath("quartz").."/settings.txt")

-- internationalization boilerplate
local MP = minetest.get_modpath(minetest.get_current_modname())
local S, NS = dofile(MP.."/intllib.lua")

--
--  Item Registration
--

--  Quartz Crystal
minetest.register_craftitem("quartz:quartz_crystal", {
	description = S("Quartz Crystal"),
	inventory_image = "quartz_crystal_full.png",
})
minetest.register_craftitem("quartz:quartz_crystal_piece", {
	description = S("Quartz Crystal Piece"),
	inventory_image = "quartz_crystal_piece.png",
})

--
-- Node Registration
--

--  Ore
-- minetest.register_node("quartz:quartz_ore", {
-- 	description = S("Quartz Ore"),
-- 	tiles = {"default_stone.png^quartz_ore.png"},
-- 	groups = {cracky=3, stone=1},
-- 	drop = 'quartz:quartz_crystal',
-- 	sounds = default.node_sound_stone_defaults(),
-- })

-- minetest.register_ore({
-- 	ore_type = "scatter",
-- 	ore = "quartz:quartz_ore",
-- 	wherein = "default:stone",
-- 	clust_scarcity = 10*10*10,
-- 	clust_num_ores = 6,
-- 	clust_size = 5,
-- 	y_min = -31000,
-- 	y_max = -5,
-- })

-- Quartz Block
minetest.register_node("quartz:quartz_block", {
	description = S("Quartz Block"),
	tiles = {"quartz_block.png"},
	groups = {cracky=3, oddly_breakable_by_hand=1},
	sounds = default.node_sound_glass_defaults(),
})

-- Chiseled Quartz
minetest.register_node("quartz:quartz_chiseled", {
	description = S("Chiseled Quartz"),
	tiles = {"quartz_chiseled.png"},
	groups = {cracky=3, oddly_breakable_by_hand=1},
	sounds = default.node_sound_glass_defaults(),
})

-- Quartz Pillar
minetest.register_node("quartz:quartz_pillar", {
	description = S("Quartz Pillar"),
	paramtype2 = "facedir",
	tiles = {"quartz_pillar_top.png", "quartz_pillar_top.png",
		"quartz_pillar_side.png"},
	groups = {cracky=3, oddly_breakable_by_hand=1},
	sounds = default.node_sound_glass_defaults(),
	on_place = minetest.rotate_node
})



--
-- Crafting
--
-- Quartz Crystal
minetest.register_craft({
	type = "cooking",
	cooktime = 6,
	output = "quartz:quartz_crystal",
	recipe = "basic_materials:silicon"
})

-- Quartz Crystal Piece
minetest.register_craft({
	output = '"quartz:quartz_crystal_piece" 3',
	recipe = {
		{'quartz:quartz_crystal'}
	}
})

-- Quartz Block
minetest.register_craft({
	output = '"quartz:quartz_block" 4',
	recipe = {
		{'quartz:quartz_crystal', 'quartz:quartz_crystal', ''},
		{'quartz:quartz_crystal', 'quartz:quartz_crystal', ''},
		{'', '', ''}
	}
})

minetest.register_craft({
	output = 'quartz:quartz_block',
	recipe = {
		{'technic:marble', 'dye:white'},
	}
})

-- Chiseled Quartz
minetest.register_craft({
	output = 'quartz:quartz_chiseled 4',
	recipe = {
		{'quartz:quartz_block', 'quartz:quartz_block', ''},
		{'quartz:quartz_block', 'quartz:quartz_block', ''},
		{'',             '',             ''},
	}
})

-- Quartz Pillar
minetest.register_craft({
	output = 'quartz:quartz_pillar 2',
	recipe = {
		{'quartz:quartz_block', '', ''},
		{'quartz:quartz_block', '', ''},
		{'', '', ''},
	}
})

--
-- ABMS
--

-- local dirs2 = {12, 9, 18, 7, 12}

-- -- Replace all instances of the horizontal quartz pillar with the
-- minetest.register_abm({
-- 	nodenames = {"quartz:quartz_pillar_horizontal"},
-- 	interval = 1,
-- 	chance = 1,
-- 	action = function(pos, node, active_object_count, active_object_count_wider)
-- 		local fdir = node.param2 or 0
-- 			nfdir = dirs2[fdir+1]
-- 		minetest.add_node(pos, {name = "quartz:quartz_pillar", param2 = nfdir})
-- 	end,
-- })

--
-- Compatibility with stairsplus
--

if minetest.global_exists("stairsplus") then
	stairsplus:register_all("quartz", "block", "quartz:quartz_block", {
		description = "Quartz Block STAIRSPLUS",
		tiles  = {"quartz_block.png"},
		groups = {cracky=3, oddly_breakable_by_hand=1},
		sounds = default.node_sound_glass_defaults()
	})

	stairsplus:register_all("quartz", "chiseled", "quartz:quartz_chiseled", {
		description = "Chiseled Quartz",
		tiles  = {"quartz_chiseled.png"},
		groups = {cracky=3, oddly_breakable_by_hand=1},
		sounds = default.node_sound_glass_defaults()
	})

	stairsplus:register_all("quartz", "pillar", "quartz:quartz_pillar", {
		description = "Quartz Pillar",
		tiles  = {"quartz_pillar_top.png", "quartz_pillar_top.png",
			"quartz_pillar_side.png"},
		groups = {cracky=3, oddly_breakable_by_hand=1},
		sounds = default.node_sound_glass_defaults()
	})
end

--
-- Deprecated
--

-- if settings:get_bool("ENABLE_HORIZONTAL_PILLAR") then
-- 	-- Quartz Pillar (horizontal)
-- 	minetest.register_node("quartz:quartz_pillar_horizontal", {
-- 			description = "Quartz Pillar Horizontal",
-- 			tiles = {"quartz_pillar_side.png", "quartz_pillar_side.png",
-- 				"quartz_pillar_side.png^[transformR90",
-- 				"quartz_pillar_side.png^[transformR90", "quartz_pillar_top.png",
-- 				"quartz_pillar_top.png"},
-- 			paramtype2 = "facedir",
-- 			drop = 'quartz:quartz_pillar',
-- 			groups = {cracky=3, oddly_breakable_by_hand=1,
-- 				not_in_creative_inventory=1},
-- 			sounds = default.node_sound_glass_defaults(),
-- 	})
-- end
