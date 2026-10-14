-- Provides the shared applicator registry with all applicators pre-registered.
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
registry.register(require("applicators.lab"))

return registry
