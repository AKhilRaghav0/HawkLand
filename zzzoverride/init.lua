--minetest.register_on_mods_loaded(function()

   minetest.override_item("default:sand", {
        groups={crumbly = 3, falling_node = 0, sand = 1}
})

minetest.override_item("default:desert_sand", {
        groups={crumbly = 3, falling_node = 0, sand = 1}
})

minetest.override_item("default:silver_sand", {
        groups={crumbly = 3, falling_node = 0, sand = 1}
})

minetest.override_item("default:gravel", {
        groups={crumbly = 2, falling_node = 0}
})



minetest.override_item("default:snow", {
        groups={crumbly = 2, falling_node = 0}
})

minetest.override_item("ethereal:sandy", {
        groups={crumbly = 3, falling_node = 0, sand = 1, not_in_creative_inventory = 0}
})

minetest.override_item("default:lava_source", {
	liquidtype = "none",
	liquid_alternative_flowing = "none",
	liquid_alternative_source = "none",
	groups = {lava = 3, igniter = 1},
	walkable = true,
	pointable = true,
	diggable = true,
	buildable_to = true,
	is_ground_content = true,
})

minetest.override_item("default:lava_flowing", {
	liquidtype = "none",
	liquid_alternative_flowing = "none",
	liquid_alternative_source = "none",
	groups = {igniter = 1, cracky = 2},
	walkable = true,
	pointable = true,
	diggable = true,
	buildable_to = true,
	is_ground_content = true,
})

--end)





