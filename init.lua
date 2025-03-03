vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require 'settings'
require 'keymaps'

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup {
  ------------------------------------------------------------------------------
  -- 1. Basic Plugins & Utilities
  ------------------------------------------------------------------------------
  { -- Automatically adjust shiftwidth and expandtab
    'tpope/vim-sleuth',
  },

  { -- Gitsigns: Display Git changes and blame
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup {
        current_line_blame = true,
      }
    end,
  },
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    config = function()
      require('toggleterm').setup {
        open_mapping = [[<c-\>]], -- Open/close terminal with Ctrl+\
        direction = 'float', -- Open Lazygit in a floating window
        float_opts = {
          border = 'curved', -- Add a border to the floating window
        },
      }
    end,
  },
  {
    'windwp/nvim-ts-autotag',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('nvim-ts-autotag').setup()
    end,
  },
  {
    'p00f/nvim-ts-rainbow',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('nvim-treesitter.configs').setup {
        auto_install = true,
        ensure_installed = {
          'bash',
          'c',
          'diff',
          'html',
          'css',
          'javascript',
          'typescript',
          'tsx',
          'json',
          'lua',
          'luadoc',
          'markdown',
          'markdown_inline',
          'query',
          'vim',
          'vimdoc',
        },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = { enable = true },
        rainbow = {
          enable = true,
          extended_mode = true,
          max_file_lines = 1000,
        },
      }
    end,
  },
  {
    'kevinhwang91/nvim-ufo',
    dependencies = { 'kevinhwang91/promise-async' },
    config = function()
      require('ufo').setup {
        provider_selector = function()
          return { 'treesitter', 'indent' }
        end,
      }
    end,
  },
  {
    'mattn/emmet-vim',
    init = function()
      vim.g.user_emmet_mode = 'a' -- Enable Emmet in all modes
      vim.g.user_emmet_leader_key = '<C-y>' -- Set Emmet trigger key
    end,
  },
  { -- Which-key: Shows available keybindings
    'folke/which-key.nvim',
    event = 'VimEnter',
    opts = {
      delay = 0,
      icons = {
        mappings = vim.g.have_nerd_font,
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
          F1 = '<F1>',
          F2 = '<F2>',
          F3 = '<F3>',
          F4 = '<F4>',
          F5 = '<F5>',
          F6 = '<F6>',
          F7 = '<F7>',
          F8 = '<F8>',
          F9 = '<F9>',
          F10 = '<F10>',
          F11 = '<F11>',
          F12 = '<F12>',
        },
      },
      spec = {
        { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
        { '<leader>d', group = '[D]ocument' },
        { '<leader>r', group = '[R]ename' },
        { '<leader>s', group = '[S]earch' },
        { '<leader>w', group = '[W]orkspace' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      },
    },
  },

  { -- Nvim-tree: File explorer with keybinding
    'nvim-tree/nvim-tree.lua',
    event = 'VimEnter',
    config = function()
      require('nvim-tree').setup {
        filters = {
          dotfiles = false, -- Keep this false to show dotfiles, or true to hide all dotfiles
          custom = { '^.git$' }, -- Hide .git folder
          exclude = { '^%.env$' },
        },
        renderer = {
          root_folder_label = false, -- Remove the `~` indicator at the top
          icons = {
            glyphs = {
              default = '',
              symlink = '',
              folder = {
                arrow_open = '',
                arrow_closed = '',
                default = '',
                open = '',
                empty = '',
                empty_open = '',
                symlink = '',
              },
              git = {
                unstaged = '✗',
                staged = '✓',
                unmerged = '',
                renamed = '➜',
                untracked = '★',
                deleted = '',
                ignored = '◌',
              },
            },
          },
        },
      }
      vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeToggle<CR>', { desc = 'Toggle File Explorer' })
    end,
  },

  { 'wakatime/vim-wakatime' },
  { 'github/copilot.vim' },

  ------------------------------------------------------------------------------
  -- 2. Formatting & Linting
  ------------------------------------------------------------------------------
  { -- null-ls: Integrates external formatters and linters
    'jose-elias-alvarez/null-ls.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local null_ls = require 'null-ls'
      null_ls.setup {
        sources = {
          null_ls.builtins.formatting.stylua, -- Stylua for Lua formatting (ensure it's installed in your PATH)
          null_ls.builtins.formatting.prettier, -- Prettier for HTML, JavaScript, etc.
          null_ls.builtins.diagnostics.eslint,
          null_ls.builtins.code_actions.eslint,
        },
      }
    end,
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    version = '^3.0', -- Ensure you're using version 3
    config = function()
      require('ibl').setup {
        indent = {
          char = '│', -- Character to use for the indent line
          tab_char = '│', -- Character to use for tab indentation
        },
        scope = {
          show_start = false, -- Disable scope start
          show_end = false, -- Disable scope end
        },
        exclude = {
          filetypes = {
            'help',
            'dashboard',
            'neo-tree',
            'Trouble',
            'lazy',
            'mason',
            'toggleterm',
            'lspinfo',
          },
        },
      }
    end,
  },
  {
    'kevinhwang91/nvim-ufo',
    dependencies = { 'kevinhwang91/promise-async' },
    config = function()
      require('ufo').setup {
        provider_selector = function()
          return { 'treesitter', 'indent' }
        end,
      }
    end,
  },
  { -- Conform: Format on save using external formatters
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        local disable_filetypes = { c = true, cpp = true }
        return {
          timeout_ms = 5000,
          lsp_format = disable_filetypes[vim.bo[bufnr].filetype] and 'never' or 'fallback',
        }
      end,
      formatters_by_ft = {
        lua = { 'stylua' }, -- Use stylua for Lua
        javascript = { 'prettier' },
        typescript = { 'prettier' },
        css = { 'prettier' },
        scss = { 'prettier' },
        html = { 'prettier' }, -- Use prettier for HTML
      },
    },
  },

  ------------------------------------------------------------------------------
  -- 3. Statusline, Debugging, & Miscellaneous Utilities
  ------------------------------------------------------------------------------
  { -- Lualine: Statusline
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup {
        options = {
          theme = 'auto',
          section_separators = '',
          component_separators = '',
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'branch', 'diff', 'diagnostics' },
          lualine_c = { 'filename' },
          lualine_x = { 'encoding', 'fileformat', 'filetype' },
          lualine_y = { 'progress' },
          lualine_z = { 'location' },
        },
      }
    end,
  },

  { -- nvim-dap: Debug Adapter Protocol for debugging JavaScript
    'mfussenegger/nvim-dap',
    config = function()
      local dap = require 'dap'
      dap.adapters.node2 = {
        type = 'executable',
        command = 'node',
        args = { os.getenv 'HOME' .. '/.local/share/nvim/mason/packages/node-debug2-adapter/out/src/nodeDebug.js' },
      }
      dap.configurations.javascript = {
        {
          name = 'Launch Node.js',
          type = 'node2',
          request = 'launch',
          program = '${file}',
          cwd = vim.fn.getcwd(),
          sourceMaps = true,
          protocol = 'inspector',
          console = 'integratedTerminal',
        },
      }
    end,
  },

  { -- Comment.nvim: Easily comment code
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end,
  },

  { -- nvim-autopairs: Automatically complete pairs
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = function()
      require('nvim-autopairs').setup {}
    end,
  },

  { -- Spectre: Search and replace tool
    'nvim-pack/nvim-spectre',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('spectre').setup()
    end,
  },

  { -- Telescope: Fuzzy finder and more
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      require('telescope').setup {
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
      vim.keymap.set('n', '<leader>/', function()
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })
      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })
      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })
    end,
  },

  { -- Lazydev: For developing local Lua plugins with lazy.nvim
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },

  ------------------------------------------------------------------------------
  -- 4. LSP & Autocompletion Configuration
  ------------------------------------------------------------------------------
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason.nvim', opts = { ensure_installed = { 'prettier', 'stylua', 'eslint', 'eslint_d' } } },
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      require('mason').setup()
      require('mason-lspconfig').setup {
        ensure_installed = { 'ts_ls', 'tailwindcss', 'cssls', 'lua_ls', 'html' }, -- Correct server names
        automatic_installation = true,
      }
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
      if vim.g.have_nerd_font then
        local signs = { ERROR = '', WARN = '', INFO = '', HINT = '' }
        for type, icon in pairs(signs) do
          local hl = 'DiagnosticSign' .. type
          vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
        end
      end
      local servers = {
        ts_ls = { -- Correct server name for TypeScript (typescript-language-server)
          on_attach = function(client, bufnr)
            client.server_capabilities.documentFormattingProvider = false
            local map = function(keys, func, desc)
              vim.keymap.set('n', keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
            end
            vim.api.nvim_create_autocmd('BufWritePre', {
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.code_action {
                  context = { only = { 'source.fixAll' }, diagnostics = {} },
                  apply = true,
                }
              end,
            })
            map('<leader>oi', function()
              vim.lsp.buf.code_action {
                context = { only = { 'source.organizeImports' }, diagnostics = {} },
                apply = true,
              }
            end, '[O]rganize [I]mports')
          end,
          capabilities = capabilities,
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = 'all',
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
              },
              preferences = { importModuleSpecifierPreference = 'non-relative', quotePreference = 'single' },
            },
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = 'all',
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
              },
              preferences = { importModuleSpecifierPreference = 'non-relative', quotePreference = 'single' },
            },
          },
        },
        tailwindcss = {
          filetypes = { 'html', 'css', 'scss', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' },
        },
        cssls = {},
        lua_ls = {
          settings = {
            Lua = {
              completion = { callSnippet = 'Replace' },
            },
          },
        },
        html = {}, -- HTML LSP for intellisense
      }
      local ensure_installed = vim.tbl_keys(servers)
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }
      require('mason-lspconfig').setup {
        ensure_installed = ensure_installed,
        automatic_installation = true,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },
  { -- nvim-cmp: Autocompletion engine configuration
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
      },
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-cmdline',
    },
    config = function()
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      luasnip.config.setup {}
      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = 'menu,menuone,noinsert' },
        mapping = cmp.mapping.preset.insert {
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-y>'] = cmp.mapping.confirm { select = true },
          ['<C-Space>'] = cmp.mapping.complete {},
          ['<C-l>'] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),
          ['<C-h>'] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),
        },
        sources = cmp.config.sources {
          { name = 'lazydev', group_index = 0 },
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
          { name = 'buffer' },
        },
      }
    end,
  },

  ------------------------------------------------------------------------------
  -- 5. Look & Feel: Colorscheme, Todo Comments, and Mini Plugins
  ------------------------------------------------------------------------------
  { -- Colorscheme: Tokyonight with custom settings
    'folke/tokyonight.nvim',
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'tokyonight-night'
      vim.cmd.hi 'Comment gui=none'
    end,
  },
  { -- Todo-comments: Highlight TODOs and FIXMEs
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },
  -- {
  --   'sphamba/smear-cursor.nvim',
  -- },
  { -- mini.nvim: Additional utilities (text objects, surround, statusline)
    'echasnovski/mini.nvim',
    config = function()
      require('mini.ai').setup { n_lines = 500 }
      require('mini.surround').setup()
      require('mini.statusline').setup {
        use_icons = vim.g.have_nerd_font,
        content = {
          active = function()
            return '%2l:%-2v'
          end,
        },
      }
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    dependencies = {
      'windwp/nvim-ts-autotag', -- Auto-tagging for HTML/JSX
      'p00f/nvim-ts-rainbow', -- Rainbow parentheses and tag highlighting
    },
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = {
          'bash',
          'c',
          'diff',
          'html',
          'css',
          'javascript',
          'typescript',
          'tsx',
          'json',
          'lua',
          'luadoc',
          'markdown',
          'markdown_inline',
          'query',
          'vim',
          'vimdoc',
        },
        auto_install = true,
        highlight = { enable = true, additional_vim_regex_highlighting = false },
        indent = { enable = true, disable = { 'ruby' } },
        autotag = { enable = true }, -- Enable auto-tagging
        rainbow = { enable = true, extended_mode = true, max_file_lines = 1000 }, -- Rainbow parentheses and tags
        fold = { enable = true }, -- Enable Treesitter-based folding
      }
    end,
  },
  ------------------------------------------------------------------------------
  -- 6. UI Extras
  ------------------------------------------------------------------------------
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
}
