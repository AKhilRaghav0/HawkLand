-- streets mod was a bit ... big ... on node id's so I forked the textures to make this more compacted version.
-- https://github.com/mrbid/Minetest-Worldmods

asphalt_colors = {'black', 'blue', 'red', 'yellow'}

function firstToUpper(str)
	return (str:gsub("^%l", string.upper))
end

function fancy_string(name)
    name = name:gsub(".*:", "")
    name = name:gsub('%W', ' ')
    name = name:gsub("(%l)(%w*)", function(a,b) return string.upper(a)..b end)
    return name
end

function register_asphalt(color)

    minetest.register_node("roadnodes:asphalt_" .. color,
    {
        description = ("Asphalt " .. firstToUpper(color)),
        tiles = {"streets_asphalt_" .. color .. ".png"},
        groups = {cracky=3, oddly_breakable_by_hand=2},
        sounds = default.node_sound_stone_defaults(),
        paramtype2 = 'facedir',
        on_place = minetest.rotate_node,
    })

    minetest.register_craft({
        output = "roadnodes:asphalt_" .. color,
        recipe = {
            {'default:stone', 'dye:' .. color},
        }
    })

end

function register_asphalt_marking(cd, color, marking)

    minetest.register_node("roadnodes:asphalt_" .. color .. "_" .. marking,
    {
        description = ("Asphalt " .. firstToUpper(color) .. " " .. fancy_string(marking)),
        tiles = {"streets_asphalt_" .. color .. ".png^streets_" .. marking .. ".png"},
        groups = {cracky=3, oddly_breakable_by_hand=2},
        sounds = default.node_sound_stone_defaults(),
        paramtype2 = 'facedir',
        on_place = minetest.rotate_node,
    })

    minetest.register_craft({
        output = "roadnodes:asphalt_" .. color .. "_" .. marking,
        recipe = {
            {'roadnodes:asphalt_' .. color, cd},
        }
    })

end

function register_asphalt_marking_all(cd, marking)
    for i, clr in ipairs(asphalt_colors) do
        register_asphalt_marking(cd, clr, marking)
    end
end

-- generate asphalt blocks
for i, clr in ipairs(asphalt_colors) do
    register_asphalt(clr);
end

-- generate asphalt road markings
register_asphalt_marking_all("baldcypress:leaves", "arrow_left_right");
register_asphalt_marking_all("cherrytree:blossom_leaves", "arrow_right");
register_asphalt_marking_all("cherrytree:leaves", "arrow_right_straight");
register_asphalt_marking_all("chestnuttree:leaves", "arrow_straight");
register_asphalt_marking_all("clementinetree:leaves", "dashed_center_line");
register_asphalt_marking_all("default:blueberry_bush_leaves", "dashed_center_line_wide");
register_asphalt_marking_all("default:bush_leaves", "dashed_side_line");
register_asphalt_marking_all("ethereal:bananaleaves", "dashed_side_line_wide");
register_asphalt_marking_all("ethereal:birch_leaves", "double_dashed_center_line");
register_asphalt_marking_all("ethereal:frost_leaves", "double_solid_center_line");
register_asphalt_marking_all("ethereal:lemon_leaves", "double_solid_center_line_corner");
register_asphalt_marking_all("ethereal:olive_leaves", "double_solid_center_line_crossing");
register_asphalt_marking_all("ethereal:orange_leaves", "double_solid_center_line_tjunction");
register_asphalt_marking_all("ethereal:palmleaves", "mixed_center_line");
register_asphalt_marking_all("ethereal:redwood_leaves", "solid_center_line");
register_asphalt_marking_all("ethereal:sakura_leaves", "solid_center_line_corner");
register_asphalt_marking_all("ethereal:sakura_leaves2", "solid_center_line_crossing");
register_asphalt_marking_all("ethereal:yellowleaves", "solid_center_line_tjunction");
register_asphalt_marking_all("hollytree:leaves", "solid_center_line_wide");
register_asphalt_marking_all("jacaranda:blossom_leaves", "solid_center_line_wide_corner");
register_asphalt_marking_all("larch:leaves", "solid_center_line_wide_crossing");
register_asphalt_marking_all("mahogany:leaves", "solid_center_line_wide_tjunction");
register_asphalt_marking_all("maple:leaves", "solid_side_line");
register_asphalt_marking_all("moretrees:apple_tree_leaves", "solid_side_line_combinated_corner");
register_asphalt_marking_all("moretrees:beech_leaves", "solid_side_line_corner");
register_asphalt_marking_all("moretrees:birch_leaves", "solid_side_line_wide");
register_asphalt_marking_all("moretrees:cedar_leaves", "solid_side_line_wide_corner");
register_asphalt_marking_all("moretrees:date_palm_leaves", "solid_stripe");
register_asphalt_marking_all("moretrees:fir_leaves", "solid_line_offset");

-- some aliases
-- minetest.register_alias("streets:asphalt", "roadnodes:asphalt_black")
-- minetest.register_alias("streets:mark_double_solid_yellow_center_line_on_asphalt", "roadnodes:asphalt_black_double_solid_center_line")
-- minetest.register_alias("streets:mark_solid_white_center_line_on_asphalt", "roadnodes:asphalt_black_solid_center_line")

minetest.register_alias("streets:asphalt", "roadnodes:asphalt_red")
minetest.register_alias("streets:mark_double_solid_yellow_center_line_on_asphalt", "roadnodes:asphalt_red_solid_center_line")
minetest.register_alias("streets:mark_solid_white_center_line_on_asphalt", "roadnodes:asphalt_red_double_solid_center_line")