local function cardinal_pictures(x, tint)
	local x_hr = 128 * x

	return {
		layers = {
			-- Base
			{
				filename = "__reskins-assets-angels__/graphics/entity/valve/valve-base.png",
				priority = "extra-high",
				x = x_hr,
				width = 128,
				height = 128,
				scale = 0.5,
			},
			-- Mask
			{
				filename = "__reskins-assets-angels__/graphics/entity/valve/valve-mask.png",
				priority = "extra-high",
				x = x_hr,
				width = 128,
				height = 128,
				tint = tint,
				scale = 0.5,
			},
		},
	}
end

local animations = {
	north = cardinal_pictures(0, inputs.tint),
	east = cardinal_pictures(1, inputs.tint),
	south = cardinal_pictures(2, inputs.tint),
	west = cardinal_pictures(3, inputs.tint),
}

---@type data.ValvePrototype|data.StorageTankPrototype
local entity = {}

if map.type == "storage-tank" then
	entity.pictures = {
		picture = animations,
	}
else
	entity.animations = animations
end
