local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

capabilities.workspace = {
  configuration = true,
  didChangeWatchedFiles = {
    dynamicRegistration = true
  },
  didChangeConfiguration = {
    dynamicRegistration = true
  }
}


vim.cmd(
  [[command! -nargs=1 Class let s:dir=expand('%:p:h') | call system('bash -c "cd ' . s:dir .' && cc ' . <q-args> . '"') | Ex ]])

local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', "v:lua.vim.lsp.omnifunc")
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup('Format', { clear = false }),
    buffer = bufnr,
    callback = function()
      vim.lsp.buf.format()
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

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = "/home/eron/workspaces/" .. project_name

local config = {
  flags = {
    allow_incremental_sync = true
  },
  cmd = {
    -- 💀
    '/home/eron/jdtls/bin/jdtls', -- or '/path/to/java17_or_newer/bin/java'
    -- depends on if `java` is in your $PATH env variable and if it points to the right version.

    --'-Declipse.application=org.eclipse.jdt.ls.core.id1',
    --'-Dosgi.bundles.defaultStartLevel=4',
    --'-Declipse.product=org.eclipse.jdt.ls.core.product',
    --'-Dlog.protocol=true',
    --'-Dlog.level=ALL',
    --'-Xms1G',
    --'--add-modules=ALL-SYSTEM',
    --'--add-opens', 'java.base/java.util=ALL-UNNAMED',
    --'--add-opens', 'java.base/java.lang=ALL-UNNAMED',

    -- 💀
    --'-jar', '/home/eronads/jdtls/plugins/org.eclipse.equinox.launcher_1.6.500.v20230622-2056.jar',
    -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                                       ^^^^^^^^^^^^^^
    -- Must point to the                                                     Change this to
    -- eclipse.jdt.ls installation                                           the actual version


    '-configuration', '/home/eron/jdtls/config_linux',

    -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        ^^^^^^
    -- Must point to the                      Change to one of `linux`, `win` or `mac`
    -- eclipse.jdt.ls installation            Depending on your system.
    '-data', workspace_dir
  },
  root_dir = require("jdtls.setup").find_root({ 'gradlew', '.git', 'mvnw' }),
  on_attach = on_attach,
  capabilities = capabilities,
  on_init = function(client, _)
    client.notify('workspace/didChangeConfiguration', { settings = config.settings })
  end,
  init_options = {
    bundles = {
      vim.fn.glob("/home/eron/.config/nvim/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar", 1)
    };
  },
  settings = {
    java = {
      format = {
        settings = {
          url = '/home/eron/.config/nvim/ftplugin/eclipse-formatter.xml'
        }
      },
      signatureHelp = { enabled = true },
      contentProvider = { preferred = 'fernflower' },
      completion = {
        favoriteStaticMembers = {
          "org.hamcrest.MatcherAssert.assertThat",
          "org.springframework.security.config.Customizer.withDefaults",
          "org.hamcrest.Matchers.*",
          "org.hamcrest.CoreMatchers.*",
          "org.junit.jupiter.api.Assertions.*",
          "java.util.Objects.requireNonNull",
          "java.util.Objects.requireNonNullElse",
          "org.mockito.Mockito.*",
        },
        filteredTypes = {
          "com.sun.*",
          "io.micrometer.shaded.*",
          "java.awt.*",
          "jdk.*",
          "sun.*",
        },
      },
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },
      codeGeneration = {
        toString = {
          template = "${object.className}1{${member.name()}=${member.value}, ${otherMembers}}"
        },
        hashCodeEquals = {
          useJava7Objects = true,
        },
        useBlocks = true,
      },
      configuration = {
        runtimes = {
          {
            name = "JavaSE-17",
            path = "/home/eron/.sdkman/candidates/java/17.0.8.1-tem",
            default = true
          },
          {
            name = "JavaSE-1.8",
            path = "/home/eron/.sdkman/candidates/java/8.0.392-librca"
          }
        }
      },
      import = {
        gradle = {
          java = {
            home = "/home/eron/.sdkman/candidates/java/8.0.392-librca"
          }
        }
      }
    },
  },
}


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


require('jdtls').start_or_attach(config)
