local M = {}

local utils = require('searchbox.utils')
local search_type = require('searchbox.search-types')
local input = require('searchbox.inputs')

local merge = utils.merge

local search_defaults = {
  reverse = false,
  exact = false,
  visual_mode = false,
  title = false,
  prompt = ' ',
  range = {-1, -1}
}

local defaults = {
  popup = {
    relative = 'win',
    position = {
      row = '5%',
      col = '95%',
    },
    size = 30,
    border = {
      style = 'rounded',
      highlight = 'FloatBorder',
      text = {
        top = ' Search ',
        top_align = 'left',
      },
    },
    win_options = {
      winhighlight = 'Normal:Normal',
    },
  },
  hooks = {
    before_mount = function() end,
    after_mount = function() end,
    on_done = function() end,
  }
}

local user_opts = nil

M.setup = function(config)
  user_opts = merge(defaults, config)
end

M.clear_matches = function()
  utils.clear_matches(vim.fn.bufnr('%'))
end

M.incsearch = function(config)
  local search_opts = merge(search_defaults, config)

  if not user_opts then
    M.setup({})
  end

  input.search(user_opts, search_opts, search_type.incsearch)
end

M.match_all = function(config)
  ------------------------
  -- Check Buffer
  
  local currentBuffer = vim.fn.expand('%')

  if currentBuffer == "Term" then
    vim.cmd 'exe "normal \\<C-W>k"'
  elseif currentBuffer == "NvimTree" then
    vim.cmd 'exe "normal \\<C-W>l"'
  else
    print("a")
  end
  -------------------------
  local search_opts = merge(search_defaults, config)

  if not user_opts then
    M.setup({})
  end

  input.search(user_opts, search_opts, search_type.match_all)
end

M.simple = function(config)
  local search_opts = merge(search_defaults, config)

  if not user_opts then
    M.setup({})
  end

  input.search(user_opts, search_opts, search_type.simple)
end

M.replace = function(config)
  -----------------------------
  -- Check Buffer
  
  local currentBuffer = vim.fn.expand('%')

  if currentBuffer == "Term" then
    vim.cmd 'exe "normal \\<C-W>k"'
  elseif currentBuffer == "NvimTree" then
    vim.cmd 'exe "normal \\<C-W>l"'
  else
    print("a")
  end
  -----------------------------
  
  if not user_opts then
    M.setup({})
  end

  local search_defaults = {
    exact = false,
    title = false,
    visual_mode = false,
    prompt = ' ',
    confirm = 'off',
    range = {-1, -1}
  }

  local search_opts = merge(search_defaults, config)

  if not utils.validate_confirm_mode(search_opts.confirm) then
    error('(SearchBox replace) Invalid value for confirm argument')
    return
  end

  local border_opts = {
    border = {
      text = {
        top = ' Replace ',
        bottom = ' 1/2 ',
        bottom_align = 'right'
      }
    }
  }

  opts = utils.merge(user_opts, {popup = border_opts})
  input.search(opts, search_opts, search_type.replace)
end

return M

