local status, packer = pcall(require, "packer")
if (not status) then
  print("Packer is not installed")
  return
end

vim.cmd [[packadd packer.nvim]]

packer.startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'flazz/vim-colorschemes'
  use 'nvim-lualine/lualine.nvim'
  use 'nvim-treesitter/nvim-treesitter'
  use 'windwp/nvim-ts-autotag'
  use 'windwp/nvim-autopairs'
  use 'kyazdani42/nvim-web-devicons'
  use {
    'nvim-telescope/telescope.nvim',
    requires = { { 'nvim-lua/plenary.nvim' } }
  }
  use 'nvim-telescope/telescope-file-browser.nvim'
  use 'lewis6991/gitsigns.nvim'
  use 'dinhhuy258/git.nvim'
  --  use 'nvim-tree/nvim-tree.lua'
  use 'jparise/vim-graphql'
  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-buffer'
  use 'L3MON4D3/LuaSnip'
  use 'onsails/lspkind.nvim'
  use 'tpope/vim-fugitive'
  use 'mattn/emmet-vim'
  use 'RRethy/nvim-base16'
  use 'mfussenegger/nvim-jdtls'
  use 'mechatroner/rainbow_csv'
  use 'stevearc/aerial.nvim'
  use 'mfussenegger/nvim-dap'
  use 'folke/neoconf.nvim'
end)
