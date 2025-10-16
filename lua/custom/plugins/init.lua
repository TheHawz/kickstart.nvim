-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    -- plugin for python docstrings
    'kkoomen/vim-doge',
    config = function()
      vim.g.doge_doc_standard_python = 'numpy'
    end,
  },
}
