---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Base.Entities

local IconBuilderFactory = require("api.icon-builder-factory")

local M = {}

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-base__/graphics/icons" })

---Gets the icon for an artillery wagon, in the tints given by `params`.
M.get_icon = icons:tinted("train-artillery-wagon"):build("get_icon")

return M
