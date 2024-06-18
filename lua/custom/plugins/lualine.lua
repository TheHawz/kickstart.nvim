return {
  'nvim-lualine/lualine.nvim',
  event = 'VimEnter', -- Sets the loading event to 'VimEnter'
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function() -- This is the function that runs, AFTER loading
    require('lualine').setup {
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename' },
        lualine_x = { 'filetype' },
        lualine_z = { 'location' },
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = {},
    }
  end,
}
