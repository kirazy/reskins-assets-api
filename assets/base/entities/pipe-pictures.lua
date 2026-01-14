-- THIS MODULE IS EXTREMELY WIP AND SUBJECT TO CHANGE.
-- The require path, function names and signatures are not stable.

local _pipes = {}

---@param material any?
---@return data.Sprite4Way
function _pipes.pipe_covers(material)
	return reskins_suppress_errors and {} or error("pipe_covers is not implemented")
end

---@param tint data.Color?
---@return data.Sprite4Way
function _pipes.pipe_pictures(tint)
	return reskins_suppress_errors and {} or error("pipe_pictures is not implemented")
end

---@param tint data.Color?
---@return data.Sprite4Way
function _pipes.simple_pipe_pictures(tint)
	return reskins_suppress_errors and {} or error("simple_pipe_pictures is not implemented")
end

return _pipes
