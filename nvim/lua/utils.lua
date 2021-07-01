local M = {}
local scopes = { o = vim.o, b = vim.bo, w = vim.wo }

function M.opt(scope, key, value)
    scopes[scope][key] = value
    if scope ~= 'o' then scopes['o'][key] = value end
end

function M.map(mode, lhs, rhs, opts)
  local options = {noremap = true, silent = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end


function M.print_table(table)
	for k, v in ipairs(table) do
		print(tostring(k) .. ' => ' .. tostring(v))
	end
end


function M.join_strings(strings)
	local result = ''
	for _, string in ipairs(strings) do
		result = result .. '\n' .. string
	end
	return result
end

function M.get_selected_text()
 	local _, linestart, colstart, _ = unpack(vim.fn.getpos("'<"))
	local _, lineend, colend, _ = unpack(vim.fn.getpos("'>"))
	local lines = vim.fn.getline(linestart, lineend)
	local lines_len = table.getn(lines)
	lines[1] = string.sub(lines[1], colstart, string.len(lines[1]))
	lines[lines_len] = string.sub(lines[lines_len], 1, colend)
	return M.join_strings(lines)
end

return M
