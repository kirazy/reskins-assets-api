---@using data
---@using Reskins.Assets
---@using Reskins.SpriteUtils

---@namespace Reskins.Assets.Base.Entities

local IconBuilderFactory = require("api.icon-builder-factory")

local M = {}

local icons = IconBuilderFactory:create({ folder = "__reskins-assets-base__/graphics/icons" })
local icon_builder = icons:tinted("train-cargo-wagon")

---Gets the icon for a cargo wagon, in the tints given by `params`.
M.get_icon = icon_builder:build("get_icon")

---Gets the icon for a cargo wagon as an `IconComposition`, in the tints given by `params`.
M.get_icon_composition = icon_builder:build_composition("get_icon_composition")

return M
