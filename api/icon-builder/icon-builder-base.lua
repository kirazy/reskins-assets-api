---@using data
---@using Reskins.SpriteUtils
---@using Reskins.SpriteUtils.Validation

---@namespace Reskins.Assets

local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")

local _assembly = require("api.icon-builder.assembly")

---Represents the methods common to every icon builder.
---
---Each method returns a copy of the builder, of the same class, with the change applied. The original is not modified.
---@class IconBuilderBase
---The state of the builder.
---@field state IconBuilderState
local IconBuilderBase = {}
IconBuilderBase.__index = IconBuilderBase

local check_stem = V.signature("stem", {
	{ "stem", Common.non_empty_string },
})

---Sets the stem of the file names of the icon to the given `stem`.
---
---The stem is the first segment of the file name of each layer, as `{stem}[-{value}...][-{part}]-{role}.png` for a
---layered icon and `{stem}[-{value}].png` for a flat icon. The name of the icon is used as the stem when no stem is
---set.
---@param stem string The stem, such as the `spidertron-heavy-runtime` in `spidertron-heavy-runtime-base.png`.
---@return self # A copy of the builder with the given `stem`.
---@throws When `stem` is `nil` or an empty string.
---@nodiscard
function IconBuilderBase:stem(stem)
	check_stem(stem)

	local state = _assembly.copy_state(self.state)
	state.stem = stem

	return setmetatable({ state = state }, getmetatable(self))
end

local check_folder = V.signature("folder", {
	{ "folder", Common.non_empty_string },
})

---Sets the folder containing the artwork of the icon to the given `folder`.
---
---The files of a layered icon are in the subfolder `{folder}/{name}`, and the file of a flat icon is in `{folder}`. The
---folder of the factory is used when no folder is set.
---@param folder string The path of the folder, such as `__reskins-assets-base__/graphics/icons`.
---@return self # A copy of the builder with the given `folder`.
---@throws When `folder` is `nil` or an empty string.
---@nodiscard
function IconBuilderBase:folder(folder)
	check_folder(folder)

	local state = _assembly.copy_state(self.state)
	state.folder = folder

	return setmetatable({ state = state }, getmetatable(self))
end

local check_mipmaps = V.signature("mipmaps", {
	{ "mipmap_count", Common.mipmap_count },
})

---Sets the number of mipmaps in the files of the icon to the given `mipmap_count`.
---
---`build_composition` adds the icon to the composition with the count, which is set on each sprite of the pictures
---lowered from it. The mipmap count of the factory is used when no count is set.
---@param mipmap_count integer The number of mipmaps in the files, between 0 and 255.
---@return self # A copy of the builder with the given `mipmap_count`.
---@throws When `mipmap_count` is not an integer between 0 and 255.
---@nodiscard
function IconBuilderBase:mipmaps(mipmap_count)
	check_mipmaps(mipmap_count)

	local state = _assembly.copy_state(self.state)
	state.mipmap_count = mipmap_count

	return setmetatable({ state = state }, getmetatable(self))
end

local check_variations = V.signature("variations", {
	{ "count", V.integer():at_least(2) },
	{ "counts", V.map(V.any(), V.integer():positive()):optional() },
})

---Sets the number of pictures of the icon, including the icon, to the given `count`.
---
---The file of the icon is the first picture, and the files of the other pictures have the number of the picture
---appended, as `{file}-{i}.png` for `i` between 1 and `count - 1`. For example, the pictures of `powder-aluminium.png`
---with a `count` of 3 are `powder-aluminium.png`, `powder-aluminium-1.png`, and `powder-aluminium-2.png`. A builder with
---variations is built with `build_composition`, and `build` raises an error.
---
---#### Parameters
---@param count integer The number of pictures, at least 2.
---@param counts? table<any, integer> The number of pictures for each value of the collection parameter that has another count, at least 1.
---
---#### Returns
---@return self # A copy of the builder with the variations set.
---
---#### Examples
---```lua
----- Create the ores of a collection with 4 pictures, and 8 pictures for bauxite.
---local get_icon_composition = icons
---    :collection("ores", "ore", V.one_of({ "bauxite-ore", "gold-ore" }))
---    :variations(4, { ["bauxite-ore"] = 8 })
---    :build_composition("get_icon_composition")
---
---local icon_data, pictures = get_icon_composition({ ore = "gold-ore" }):build()
----- The icon is ores/gold-ore/gold-ore.png, and the pictures are gold-ore.png and gold-ore-{i}.png for i between 1
----- and 3.
---```
---@throws When `count` is not an integer of at least 2.
---@throws When `counts` is not a table of positive integers.
---@nodiscard
function IconBuilderBase:variations(count, counts)
	check_variations(count, counts)

	local state = _assembly.copy_state(self.state)
	state.variations = { count = count, counts = counts and util.copy(counts) or nil }

	return setmetatable({ state = state }, getmetatable(self))
end

local check_size = V.signature("size", {
	{ "icon_size", Common.sprite_size },
})

---Sets the `icon_size` of the layers of the icon to the given `icon_size`.
---
---The icon size of the factory is used when no size is set. A layer with an `icon_size` in its options keeps that size.
---@param icon_size SpriteSizeType The size of the icon files, in pixels.
---@return self # A copy of the builder with the given `icon_size`.
---@throws When `icon_size` is not an integer between 1 and 8192.
---@nodiscard
function IconBuilderBase:size(icon_size)
	check_size(icon_size)

	local state = _assembly.copy_state(self.state)
	state.icon_size = icon_size

	return setmetatable({ state = state }, getmetatable(self))
end

return IconBuilderBase
