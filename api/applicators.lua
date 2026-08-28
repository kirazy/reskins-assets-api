-- The applicator registry every caller shares: one built from api.applicator-registry, populated with every
-- implemented applicator, and returned. This is the primary entry point for API consumers looking
-- to apply a sprite set to an arbitrary prototype.
--
-- Register an applicator here when adding a corresponding applicator definition under
-- api/applicators/.

---@namespace Reskins.Assets

local ApplicatorRegistry = require("api.applicator-registry")

---@type ApplicatorRegistry
local registry = ApplicatorRegistry.new()

registry.register(require("applicators.crafting-machine"))
registry.register(require("applicators.boiler"))
registry.register(require("applicators.accumulator"))
registry.register(require("applicators.electric-pole"))
registry.register(require("applicators.inserter"))
registry.register(require("applicators.mining-drill"))
registry.register(require("applicators.reactor"))
registry.register(require("applicators.pipe"))
registry.register(require("applicators.pipe-to-ground"))
registry.register(require("applicators.pump"))
registry.register(require("applicators.radar"))
registry.register(require("applicators.roboport"))
registry.register(require("applicators.robot-construction"))
registry.register(require("applicators.robot-logistic"))
registry.register(require("applicators.beacon"))
registry.register(require("applicators.generator"))
registry.register(require("applicators.transport-belt"))
registry.register(require("applicators.solar-panel"))
registry.register(require("applicators.storage-tank"))

return registry
