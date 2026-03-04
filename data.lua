local _icons = require("api.icons")
local _sprites = require("api.sprites")
local colors = require("__reskins-sprite-utils__.colors")

---@param name data.EntityID
---@param source_type string
---@param source_name data.EntityID
---@param icons data.IconData[]?
local function create_dummy_entity(name, source_type, source_name, icons)
	local source_entity = data.raw[source_type][source_name]

	---@type data.ItemPrototype
	local item = {
		type = "item",
		name = name,
		localised_name = name,
		icons = icons or _icons.get_icon_from_prototype(source_entity),
		stack_size = 10,
		place_result = name,
	}

	local entity = util.merge({
		util.copy(source_entity),
		{
			name = name,
			minable = { result = name },
		},
	})

	entity.next_upgrade = nil

	---@type data.RecipePrototype
	local recipe = {
		type = "recipe",
		name = name,
		ingredients = {},
		results = { { type = "item", name = name, amount = 1 } },
	}

	data:extend({ item, entity, recipe })

	return entity
end

reskins_suppress_errors = true

local tints = {
	gray = colors.from_argb("FF808080"),
	yellow = colors.from_argb("FFFFB726"),
	red = colors.from_argb("FFF22318"),
	blue = colors.from_argb("FF33B4FF"),
	purple = colors.from_argb("FFB459FF"),
	green = colors.from_argb("FF2EE55C"),
	orange = colors.from_argb("FFFF8533"),
}

-- STANDARD ASSEMBLY MACHINE TESTS
local AssemblingMachineGraphicsPack = require("graphics-packs.assembling-machine-graphics-pack")

AssemblingMachineGraphicsPack:configure({
	tint = tints.yellow,
	machine_tier = 1,
}):apply_to_entity(create_dummy_entity("ar-assembly-0", "assembling-machine", "assembling-machine-1"))
AssemblingMachineGraphicsPack:configure({
	tint = tints.red,
	machine_tier = 2,
}):apply_to_entity(create_dummy_entity("ar-assembly-1", "assembling-machine", "assembling-machine-1"))
AssemblingMachineGraphicsPack:configure({
	tint = tints.blue,
	machine_tier = 3,
}):apply_to_entity(create_dummy_entity("ar-assembly-2", "assembling-machine", "assembling-machine-2"))
AssemblingMachineGraphicsPack:configure({
	tint = tints.purple,
	machine_tier = 4,
}):apply_to_entity(create_dummy_entity("ar-assembly-3", "assembling-machine", "assembling-machine-2"))
AssemblingMachineGraphicsPack:configure({
	tint = tints.green,
	machine_tier = 5,
}):apply_to_entity(create_dummy_entity("ar-assembly-4", "assembling-machine", "assembling-machine-3"))
AssemblingMachineGraphicsPack:configure({
	tint = tints.orange,
	machine_tier = 6,
}):apply_to_entity(create_dummy_entity("ar-assembly-5", "assembling-machine", "assembling-machine-3"))

-- ELECTRIC ASSEMBLY MACHINE TESTS
-- NOTE: rescaling fluid boxes needs manual correction.
local assembly_electric_1 = create_dummy_entity("ar-assembly-electric-1", "assembling-machine", "assembling-machine-1")
AssemblingMachineGraphicsPack:configure({
	tint = tints.yellow,
	machine_tier = 2,
	use_electronics_set = true,
}):apply_to_entity(assembly_electric_1)
_sprites.rescale_prototype(assembly_electric_1, 2 / 3)

local assembly_electric_2 = create_dummy_entity("ar-assembly-electric-2", "assembling-machine", "assembling-machine-1")
AssemblingMachineGraphicsPack:configure({
	tint = tints.red,
	machine_tier = 4,
	use_electronics_set = true,
}):apply_to_entity(assembly_electric_2)
_sprites.rescale_prototype(assembly_electric_2, 2 / 3)

local assembly_electric_3 = create_dummy_entity("ar-assembly-electric-3", "assembling-machine", "assembling-machine-1")
AssemblingMachineGraphicsPack:configure({
	tint = tints.blue,
	machine_tier = 6,
	use_electronics_set = true,
}):apply_to_entity(assembly_electric_3)
_sprites.rescale_prototype(assembly_electric_3, 2 / 3)

-- INDUCTION FURNACE TESTS
local InductionFurnaceGraphicsPack = require("graphics-packs.induction-furnace-graphics-pack")
local induction_furnace_1 = create_dummy_entity("ar-induction-furnace-1", "assembling-machine", "assembling-machine-1")
_sprites.rescale_prototype(induction_furnace_1, 5 / 3)

InductionFurnaceGraphicsPack:configure({
	tint = tints.yellow,
}):apply_to_entity(induction_furnace_1)

-- ACCUMULATOR TESTS
local AccumulatorGraphicsPack = require("graphics-packs.accumulator-graphics-pack")
AccumulatorGraphicsPack:configure({
	tint = tints.yellow,
	sprite_set = "base",
}):apply_to_entity(create_dummy_entity("ar-accumulator", "accumulator", "accumulator"))
AccumulatorGraphicsPack:configure({
	tint = tints.red,
	sprite_set = "fast",
}):apply_to_entity(create_dummy_entity("ar-accumulator-fast", "accumulator", "accumulator"))
AccumulatorGraphicsPack:configure({
	tint = tints.blue,
	sprite_set = "high-capacity",
}):apply_to_entity(create_dummy_entity("ar-accumulator-high-capacity", "accumulator", "accumulator"))
AccumulatorGraphicsPack:configure({
	tint = tints.purple,
	sprite_set = "slow",
}):apply_to_entity(create_dummy_entity("ar-accumulator-slow", "accumulator", "accumulator"))
