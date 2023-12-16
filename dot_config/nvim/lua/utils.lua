
P = function(v)
  print(vim.inspect(v))
  return v
end

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

function M.get_selection()
 	local _, linestart, colstart, _ = unpack(vim.fn.getpos("'<"))
	local _, lineend, colend, _ = unpack(vim.fn.getpos("'>"))
	local lines = vim.fn.getline(linestart, lineend)
	local lines_len = table.getn(lines)
	lines[1] = string.sub(lines[1], colstart, string.len(lines[1]))
	lines[lines_len] = string.sub(lines[lines_len], 1, colend)
	return M.join_strings(lines)
end

M.get_repo_root_or_cwd = function()
  return M.get_repo_root() or vim.loop.cwd()
end

M.find_files = function()
  local repo_root = M.get_repo_root()
  local builtin = require'telescope.builtin'
  if repo_root == nil then
    builtin.find_files{cwd = vim.loop.cwd()}
  else
    builtin.git_files({cwd = repo_root})
  end
end

M.get_repo_root = function()
  local is_error = function(message) 
    local prefix = 'fatal:'
    return message:find(prefix, 1, #prefix) ~= nil
  end
  local git_cmd = 'git -C ' .. vim.loop.cwd() .. ' rev-parse --show-toplevel'
  local git_root = vim.fn.systemlist(git_cmd)[1]
  if (not git_root) or is_error(git_root) then
    return nil
  end
  return git_root
end

return M
