local path = require('plenary.path')
local files = require('telescope.builtin.files')
local git = require('telescope.builtin.git')

local m = {}

local is_fatal = function(input) 
  local prefix = 'fatal'
  return input:find(prefix, 1, #prefix) ~= nil
end

m.get_project_root = function()
  local git_cmd = 'git -C ' .. vim.loop.cwd() .. ' rev-parse --show-toplevel'
  local git_root = vim.fn.systemlist(git_cmd)[1]
  if not git_root or is_fatal(git_root) then
    return nil
  end
  return git_root
end

m.project_files = function()
  local dir = m.get_project_root()
  files.find_files({cwd = dir})
end

m.project_git_files = function() 
  local dir = m.get_project_root()
  git.files({cwd = dir})
end

m.project_grep_string = function()
  local dir = m.get_project_root()
  files.grep_string({cwd = dir})
end

m.project_live_grep = function() 
  local dir = m.get_project_root()
  files.live_grep({cwd = dir}) 
end

return m
