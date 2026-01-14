require("assets.base.icons")

local colors = require("__reskins-sprite-utils__.colors")

reskins_suppress_errors = true

local AssemblingMachineGraphicsPack = require("graphics-packs.assembling-machine-graphics-pack")

AssemblingMachineGraphicsPack:new({
	tint = colors.from_argb("FFB8E932"),
	machine_tier = 2,
}):apply_to_entity(data.raw["assembling-machine"]["assembling-machine-1"])

AssemblingMachineGraphicsPack:new({
	tint = colors.from_argb("FF35CFEB"),
	machine_tier = 4,
}):apply_to_entity(data.raw["assembling-machine"]["assembling-machine-2"])

AssemblingMachineGraphicsPack:new({
	tint = colors.from_argb("FFEB5EF0"),
	machine_tier = 6,
}):apply_to_entity(data.raw["assembling-machine"]["assembling-machine-3"])

local _icons = require("api.icons")
local _sprites = require("api.sprites")
local function get_newly_created_fake(name, source_type, source_name)
	local source_entity = data.raw[source_type][source_name]

	local item = {
		type = "item",
		name = name,
		icons = _icons.get_icon_from_prototype(source_entity),
		place_result = name,
		stack_size = 10,
	}

	local entity = util.merge({
		data.raw[source_type][source_name],
		{
			name = name,
			minable = { result = name },
		},
	})

	entity.next_upgrade = nil
	data:extend({ item, entity })

	return entity
end

local entity = get_newly_created_fake("fake-electric-asm-1", "assembling-machine", "assembling-machine-1")

AssemblingMachineGraphicsPack:new({
	tint = colors.from_argb("FF1AE4DA"),
	machine_tier = 5,
	use_electronics_set = true,
}):apply_to_entity(entity)

_sprites.rescale_prototype(entity, 2 / 3)
