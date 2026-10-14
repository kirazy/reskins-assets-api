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
