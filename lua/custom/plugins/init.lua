-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

---@module 'lazy'
---@type LazySpec
return {
  -- CTRL+<hjkl> moves across nvim splits and tmux panes seamlessly (tmux side in ~/.tmux.conf)
  { 'christoomey/vim-tmux-navigator', lazy = false },
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope.nvim' },
    config = function() -- This is the function that runs, AFTER loading
      local harpoon = require 'harpoon'
      harpoon:setup {
        settings = {
          save_on_toggle = true,
          save_on_ui_close = true,
        },
      }

      vim.keymap.set('n', '<leader>a', function() harpoon:list():add() end)
      vim.keymap.set('n', '<C-e>', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

      -- <C-1>..<C-4> require a modern terminal (kitty/WezTerm/Ghostty)
      vim.keymap.set('n', '<C-1>', function() harpoon:list():select(1) end)
      vim.keymap.set('n', '<C-2>', function() harpoon:list():select(2) end)
      vim.keymap.set('n', '<C-3>', function() harpoon:list():select(3) end)
      vim.keymap.set('n', '<C-4>', function() harpoon:list():select(4) end)

      -- Toggle previous & next buffers stored within Harpoon list
      vim.keymap.set('n', '<C-S-P>', function() harpoon:list():prev() end)
      vim.keymap.set('n', '<C-S-N>', function() harpoon:list():next() end)
    end,
  },
  -- Renders markdown in the buffer itself (headings, tables, code blocks, checkboxes).
  -- Raw text comes back on the cursor line, so you can still edit.
  {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = 'markdown',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      completions = { blink = { enabled = true } },
    },
    keys = {
      { '<leader>vm', '<cmd>RenderMarkdown toggle<cr>', desc = '[V]iew [M]arkdown render toggle' },
    },
  },
  -- Browser preview with live reload for markdown (mermaid, KaTeX), HTML and SVG.
  -- No build step; serves the file over a local HTTP server.
  {
    'brianhuster/live-preview.nvim',
    cmd = 'LivePreview',
    keys = {
      { '<leader>vp', '<cmd>LivePreview start<cr>', desc = '[V]iew [P]review in browser (md/html/svg)' },
      { '<leader>vP', '<cmd>LivePreview close<cr>', desc = '[V]iew stop [P]review' },
      { '<leader>vf', '<cmd>LivePreview pick<cr>', desc = '[V]iew pick [F]ile to preview' },
    },
    config = function()
      require('livepreview.config').set {
        port = 5500,
        browser = 'default',
        dynamic_root = false,
        sync_scroll = true,
        picker = 'telescope',
      }
    end,
  },
  {
    'yousefhadder/markdown-plus.nvim',
    ft = 'markdown',
    opts = {},
  },
  {
    'Vigemus/iron.nvim',
    config = function()
      local iron = require 'iron.core'
      local view = require 'iron.view'
      local common = require 'iron.fts.common'

      iron.setup {
        config = {
          scratch_repl = true,
          repl_definition = {
            python = {
              command = { 'uv', 'run', 'ipython', '--no-autoindent' },
              format = common.bracketed_paste_python,
              block_dividers = { '# %%', '#%%' },
            },
          },
          repl_open_cmd = view.split.botright '40%',
        },
        keymaps = {
          toggle_repl = '<leader>rr',
          restart_repl = '<leader>rR',
          send_line = '<leader>rl',
          send_code_block = '<leader>rs',
          send_code_block_and_move = '<leader>rn',
          visual_send = '<leader>rs',
          send_file = '<leader>rF',
          interrupt = '<leader>ri',
          exit = '<leader>rq',
          clear = '<leader>rx',
        },
        highlight = { italic = true },
        ignore_blank_lines = true,
      }

      vim.keymap.set('n', '<leader>rf', '<cmd>IronFocus<cr>', { desc = '[R]EPL [F]ocus' })
      vim.keymap.set('n', '<leader>rh', '<cmd>IronHide<cr>', { desc = '[R]EPL [H]ide' })
    end,
  },
  {
    'folke/trouble.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    cmd = 'Trouble',
    keys = {
      { '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', desc = '[X]  Diagnostics (project)' },
      { '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', desc = '[X]  Diagnostics (buffer)' },
      { '<leader>xq', '<cmd>Trouble qflist toggle<cr>', desc = '[X]  Quickfix list' },
    },
    opts = {},
  },
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    -- Needs `allow-passthrough on` in ~/.tmux.conf to work inside tmux.
    -- Opening a png/jpg/gif/webp/pdf/svg renders it; images, mermaid and LaTeX in markdown render inline.
    opts = {
      image = {
        enabled = true,
        doc = { inline = true, float = true, max_width = 80, max_height = 40 },
      },
    },
    keys = {
      { '<leader>vi', function() Snacks.image.hover() end, desc = '[V]iew [I]mage under cursor' },
      { '<leader>vo', function() vim.ui.open(vim.fn.expand '%:p') end, desc = '[V]iew [O]pen file in system app' },
    },
  },
  {
    'hat0uma/csvview.nvim',
    ft = { 'csv', 'tsv' },
    cmd = { 'CsvViewEnable', 'CsvViewDisable', 'CsvViewToggle' },
    opts = {
      keymaps = {
        textobject_field_inner = { 'if', mode = { 'o', 'x' } },
        textobject_field_outer = { 'af', mode = { 'o', 'x' } },
        jump_next_field_end = { '<Tab>', mode = { 'n', 'v' } },
        jump_prev_field_end = { '<S-Tab>', mode = { 'n', 'v' } },
      },
    },
    config = function(_, opts)
      require('csvview').setup(opts)
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'csv', 'tsv' },
        callback = function() vim.cmd 'CsvViewEnable' end,
      })
    end,
  },
  {
    'mfussenegger/nvim-dap-python',
    ft = 'python',
    dependencies = { 'mfussenegger/nvim-dap' },
    config = function()
      -- Use project .venv if it exists (uv), otherwise fall back to Mason's debugpy
      local venv = vim.fn.getcwd() .. '/.venv/bin/python'
      local fallback = vim.fn.stdpath 'data' .. '/mason/packages/debugpy/venv/bin/python'
      require('dap-python').setup(vim.fn.filereadable(venv) == 1 and venv or fallback)
    end,
  },
}
