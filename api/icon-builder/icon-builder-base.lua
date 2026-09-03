---@using data
---@using Reskins.SpriteUtils
---@using Reskins.SpriteUtils.Validation

---@namespace Reskins.Assets

local V = require("__reskins-sprite-utils__.validation")
local Common = require("__reskins-sprite-utils__.validation.common")

local _assembly = require("api.icon-builder.assembly")

---The base class of the icon builders, providing the `folder`, `stem`, and `size` methods.
---
---Every method returns a new builder of the same class; the builder it was called on is not
---modified.
---@class IconBuilderBase
---The state of the builder.
---@field state IconBuilderState
local IconBuilderBase = {}
IconBuilderBase.__index = IconBuilderBase

local check_stem = V.signature("stem", {
	{ "stem", Common.non_empty_string },
})

---Draws the layers of the icon from files named for the given `stem` instead of the name of the icon.
---@generic S : IconBuilderBase
---@param self S The builder.
---@param stem string The file name segment the layers of the icon are named for.
---@return S # A builder drawing from the given `stem`.
---@throws Thrown when `stem` is not a non-empty string.
---@nodiscard
function IconBuilderBase.stem(self, stem)
	check_stem(stem)

	local state = _assembly.copy_state(self.state)
	state.stem = stem

	return setmetatable({ state = state }, getmetatable(self))
end

local check_folder = V.signature("folder", {
	{ "folder", Common.non_empty_string },
})

---Draws the icon from artwork in the given `folder` instead of the folder of the catalog.
---@generic S : IconBuilderBase
---@param self S The builder.
---@param folder string The mod-relative folder containing the artwork of the icon.
---@return S # A builder drawing from the given `folder`.
---@throws Thrown when `folder` is not a non-empty string.
---@nodiscard
function IconBuilderBase.folder(self, folder)
	check_folder(folder)

	local state = _assembly.copy_state(self.state)
	state.folder = folder

	return setmetatable({ state = state }, getmetatable(self))
end

local check_size = V.signature("size", {
	{ "icon_size", Common.sprite_size },
})

---Draws the layers of the icon at the given `icon_size` instead of the size of the catalog.
---@generic S : IconBuilderBase
---@param self S The builder.
---@param icon_size SpriteSizeType The size of the artwork of the icon, in pixels.
---@return S # A builder drawing at the given `icon_size`.
---@throws Thrown when `icon_size` is not a sprite size.
---@nodiscard
function IconBuilderBase.size(self, icon_size)
	check_size(icon_size)

	local state = _assembly.copy_state(self.state)
	state.icon_size = icon_size

	return setmetatable({ state = state }, getmetatable(self))
end

return IconBuilderBase
