---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Base.Entities

local IconBuilderFactory = require("api.icon-builder-factory")

local M = {}

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-base__/graphics/icons" })

---Gets the icon for the vanilla tank, in the tints given by `params`.
M.get_icon = icons:tinted("tank"):build("get_icon")

return M
