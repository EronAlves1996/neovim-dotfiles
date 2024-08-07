-- identation
vim.cmd([[ set autoindent expandtab tabstop=2 shiftwidth=2 ]])

-- identation for php filesize
vim.cmd([[ autocmd FileType php setlocal autoindent ]])

-- linenumber
vim.cmd([[ set number ]])

-- column number
vim.cmd([[ set cc=80 ]])

-- colorscheme

vim.cmd([[ set termguicolors ]])
vim.cmd([[ colorscheme base16-hardcore ]])

-- terminal (:LocalTerm)
vim.cmd([[command! LocalTerm let s:term_dir=expand('%:p:h') | below new | call termopen([&shell], {'cwd': s:term_dir })
]])


-- tabs
vim.keymap.set("n", "<space>t", ":tab new<CR>")
vim.keymap.set("n", "tp", ":tabprevious<CR>")
vim.keymap.set("n", "tn", ":tabnext<CR>")

-- wrap
vim.cmd([[ set nowrap ]])

-- lualine
local status, lualine = pcall(require, "lualine")
if (not status) then return end

lualine.setup {
  options = {
    theme = 'auto'
  }
}
-- autotag and autopair
local status, autotag = pcall(require, "nvim-ts-autotag")
if (not status) then return end

autotag.setup({})

local status, autopairs = pcall(require, "nvim-autopairs")
if (not status) then return end

autopairs.setup({
  disable_filetype = { "TelescopePrompt", "vim" },
})



-- Telescope
local telescope = require("telescope")
local actions = require('telescope.actions')
local builtin = require("telescope.builtin")


local function telescope_buffer_dir()
  return vim.fn.expand('%:p:h')
end

local fb_actions = require "telescope".extensions.file_browser.actions

telescope.setup {
  defaults = {
    mappings = {
      n = {
        ["q"] = actions.close
      },
    },
  },
  pickers = {
    buffers = {
      mappings = {
        n = {
          ["d"] = actions.delete_buffer
        }
      }
    }
  },
  extensions = {
    aerial = {
      show_nesting = {
        ["_"] = false,
      }
    }
  }
}

vim.keymap.set("n", "tt", ":Telescope<CR>")

-- keymaps
vim.keymap.set('n', ';f',
  function()
    builtin.find_files({
      no_ignore = false,
      hidden = true
    })
  end)
vim.keymap.set('n', ';r', function()
  builtin.live_grep()
end)
vim.keymap.set('n', '\\\\', function()
  builtin.buffers()
end)
vim.keymap.set('n', ';t', function()
  builtin.help_tags()
end)
vim.keymap.set('n', ';;', function()
  builtin.resume()
end)
vim.keymap.set('n', ';e', function()
  builtin.diagnostics()
end)
vim.keymap.set("n", ";b", function()
  builtin.buffers()
end)

-- telescope browser
telescope.setup {
  defaults = {
    mappings = {
      n = {
        ["q"] = actions.close
      },
    },
  },
  extensions = {
    file_browser = {
      theme = "dropdown",
      -- disables netrw and use telescope-file-browser in its place
      hijack_netrw = true,
      mappings = {
        -- your custom insert mode mappings
        ["i"] = {
          ["<C-w>"] = function() vim.cmd('normal vbd') end,
        },
        ["n"] = {
          -- your custom normal mode mappings
          ["N"] = fb_actions.create,
          ["h"] = fb_actions.goto_parent_dir,
          ["/"] = function()
            vim.cmd('startinsert')
          end
        },
      },
    },
  },
}
telescope.load_extension("file_browser")

vim.keymap.set("n", "sf", function()
  telescope.extensions.file_browser.file_browser({
    path = "%:p:h",
    cwd = telescope_buffer_dir(),
    respect_gitignore = false,
    hidden = true,
    grouped = true,
    previewer = false,
    initial_mode = "normal",
    layout_config = { height = 40 }
  })
end)

-- gitsigns
require('gitsigns').setup {
}

-- git
local status, git = pcall(require, "git")
if (not status) then return end

git.setup({
  keymaps = {
    -- Open blame window
    blame = "<Leader>gb",
    -- Open file/folder in git repository
    browse = "<Leader>go",
  }
})

-- newtr
vim.keymap.set('n', 'nt', ':Explore<CR>')

-- neoconf 
require"neoconf".setup{}

--lsp

local lspconfig = require('lspconfig')
local protocol = require('vim.lsp.protocol')

-- format on save
local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', "v:lua.vim.lsp.omnifunc")
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup('Format', { clear = false }),
    buffer = bufnr,
    callback = function()
      vim.lsp.buf.format {
        filter = function(client)
          return client.name ~= "tsserver"
        end
      }
    end
  })
  vim.api.nvim_create_autocmd("BufDelete", {
    buffer = bufnr,
    callback = function()
      vim.api.nvim_clear_autocmds({
        buffer = bufnr,
        group = "Format"
      })
    end
  })
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  local opts = { noremap = true, silent = true }
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', '<space>K', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('v', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', '<space>f', vim.lsp.buf.format, bufopts)
  vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
end

local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.workspace = {
  didChangeWatchedFiles = {
    dynamicRegistration = true
  },
  didChangeConfiguration = {
    dynamicRegistration = true
  }
}

local language_servers = { 'tailwindcss', 'cssls', 'html', 'phpactor', 'eslint', 'gopls', 'rust_analyzer', 'ocamllsp' }

for key, value in pairs(language_servers) do
  lspconfig[value].setup {
    on_attach = on_attach,
    capabilities = capabilities
  }
end

lspconfig.tsserver.setup {
  init_options = {
    plugins = {
      {
        name = "@vue/typescript-plugin",
        location = "/home/eron/.nvm/versions/node/v18.18.0/lib/node_modules/@vue/typescript-plugin",
        languages = {"javascript", "typescript", "vue"},
      },
    },
  },
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "javascript", "typescript", "vue" },
}

lspconfig.volar.setup {
  init_options = {
    typescript = {
      tsdk = "/home/eron/.nvm/versions/node/v18.18.0/lib/node_modules/typescript/lib" 
    }
  },
  on_attach = on_attach,
  capabilities = capabilities
}

lspconfig.html.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "html", "template", "xhtml" }
}

lspconfig.lemminx.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "xml", "xhtml" } 
}

lspconfig.lua_ls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false
      }
    }
  }
}


-- efm-sources
local prettier = {
  formatCommand = 'prettierd ${INPUT}',
  formatStdin = true,
}

local phpcs = {
  lintCommand =
  "phpcs --report=emacs -q -s --runtime-set ignore_warnings_on_ext 1 --runtime-set ignore_errors_on_ext 1 --stdin-path=${INPUT} --standard=PSR12",
  lintStdin = true,
  lintFormats = { "%f:%l:%c: %m" },
  lintIgnoreExitCode = true,
  formatcommand = "phpcbf -q --stdin-path=${INPUT} --standard=PSR12 -",
  formatStdin = true,
}

lspconfig.efm.setup {
  init_options = { documentFormatting = true },
  filetypes = { "typescript", "php", "template", "typescriptreact", "vue" },
  settings = {
    rootMarkers = { "tsconfig.json", "composer.json", ".git/" },
    languages = {
      typescript = { prettier },
      typescriptreact = { prettier },
      javascript = { prettier },
      vue = { prettier },
      php = { prettier },
      template = { prettier },
    }
  },
  capabilities = capabilities,
  on_attach = on_attach
}

-- cmp
local cmp = require 'cmp';
local lspkind = require 'lspkind'

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end
  },
  mapping = cmp.mapping.preset.insert({
    ['C-Space'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'buffer' },
  }),
  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol',       -- show only symbol annotations
      maxwidth = 50,         -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
      ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)

      -- The function below will be called before any actual modifications from lspkind
      -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
      before = function(entry, vim_item)
        return vim_item
      end
    })
  }
})

vim.cmd [[ set completeopt=menuone,noinsert,noselect
highlight! default link CmpItemKind CmpItemMenuDefault
]]


-- treesitter
require 'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true
  }
}


-- aerial (outline)
require 'aerial'.setup {}

telescope.load_extension("aerial")
--telescope.extensions.aerial.aerial()

-- Leader key 
vim.cmd([[ let mapleader="," ]])

-- DAP
vim.keymap.set('n', '<F5>', function() require('dap').continue() end)
vim.keymap.set('n', '<Leader>5', function() require('dap').step_over() end)
vim.keymap.set('n', '<Leader>6', function() require('dap').step_into() end)
vim.keymap.set('n', '<Leader>7', function() require('dap').step_out() end)
vim.keymap.set('n', '<Leader>b', function() require('dap').toggle_breakpoint() end)
vim.keymap.set('n', '<Leader>B', function() require('dap').set_breakpoint() end)
vim.keymap.set('n', '<Leader>lp', function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
vim.keymap.set('n', '<Leader>dr', function() require('dap').repl.open() end)
vim.keymap.set('n', '<Leader>dl', function() require('dap').run_last() end)
vim.keymap.set({'n', 'v'}, '<Leader>dh', function()
  require('dap.ui.widgets').hover()
end)
vim.keymap.set({'n', 'v'}, '<Leader>dp', function()
  require('dap.ui.widgets').preview()
end)
vim.keymap.set('n', '<Leader>df', function()
  local widgets = require('dap.ui.widgets')
  widgets.centered_float(widgets.frames)
end)
vim.keymap.set('n', '<Leader>ds', function()
  local widgets = require('dap.ui.widgets')
  widgets.centered_float(widgets.scopes)
end)

