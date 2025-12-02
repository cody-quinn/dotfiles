{
  pkgs,
  ...
}:

let
  fidget-nvim-legacy = pkgs.vimUtils.buildVimPlugin {
    pname = "fidget.nvim-legacy";
    version = "2023-06-10";
    src = pkgs.fetchFromGitHub {
      owner = "j-hui";
      repo = "fidget.nvim";
      rev = "90c22e47be057562ee9566bad313ad42d622c1d3";
      sha256 = "N3O/AvsD6Ckd62kDEN4z/K5A3SZNR15DnQeZhH6/Rr0=";
    };
    meta.homepage = "https://github.com/j-hui/fidget.nvim/";
  };
in
{
  # Setting up neovim and making it the default editor
  programs.neovim.enable = true;

  programs.neovim.defaultEditor = true;
  programs.neovim.viAlias = true;
  programs.neovim.vimAlias = true;

  # Installing neovim plugins
  programs.neovim.plugins = with pkgs.vimPlugins; [
    plenary-nvim
    nui-nvim

    lualine-nvim
    indent-blankline-nvim
    which-key-nvim
    vim-sleuth
    fidget-nvim-legacy
    comment-nvim

    # Color scheme
    gruvbox-nvim
    onedark-nvim

    # Nix integration
    direnv-vim

    # Terminal integration
    vim-floaterm

    # Git Related
    vim-fugitive
    vim-rhubarb
    gitsigns-nvim

    # Treesitter
    nvim-treesitter.withAllGrammars
    nvim-treesitter-context
    nvim-treesitter-textobjects

    # Telescope
    telescope-nvim
    telescope-fzf-native-nvim

    # Neotree
    neo-tree-nvim
    nvim-web-devicons

    # Cokeline
    nvim-cokeline

    # Language Support
    nvim-lspconfig
    emmet-vim

    # Autocompletion
    luasnip
    nvim-cmp
    cmp-nvim-lsp
    cmp_luasnip
  ];

  # Configuring neovim and installing packages required by our config
  programs.neovim.extraPackages = with pkgs; [
    ripgrep
  ];

  programs.neovim.extraLuaConfig = ''
    local get_hl_attr = require('cokeline.hlgroups').get_hl_attr

    -- Setting <space> as leader key
    vim.g.mapleader = ' '
    vim.g.maplocalleader = ' '

    -- Setting the color scheme
    require('gruvbox').setup {
      contrast = "hard"
    }

    vim.o.background = 'dark'
    vim.cmd.colorscheme 'gruvbox'

    vim.api.nvim_set_hl(0, "SignColumn", {
      bg = get_hl_attr("Normal", "bg")
    })

    -- Setting web devicons
    require('nvim-web-devicons').setup {
      override_by_filename = {
        ["license-mit"] = {
          icon = "",
          color = "#d0bf41",
          cterm_color = "185",
          name = "License",
        },
        ["license-apache"] = {
          icon = "",
          color = "#d0bf41",
          cterm_color = "185",
          name = "License",
        },
      };

      override_by_extension = {
        ["rs"] = {
          icon = "",
        },
      };
    }

    -- Generic settings for neovim
    vim.o.mouse = 'a'
    vim.o.hlsearch = false
    vim.o.breakindent = true

    vim.o.clipboard = 'unnamedplus'
    vim.o.undofile = true

    vim.o.ignorecase = true
    vim.o.smartcase = true

    vim.o.updatetime = 250
    vim.o.timeout = true
    vim.o.timeoutlen = 300

    vim.o.completeopt = 'menuone,noselect'
    vim.o.termguicolors = true
    vim.wo.number = true
    vim.wo.relativenumber = true
    vim.wo.signcolumn = 'yes'

    vim.o.tabstop = 4
    vim.o.softtabstop = 4
    vim.o.shiftwidth = 4
    vim.o.expandtab = true

    -- Settings for graphical environments like neovide
    vim.o.guifont = 'JetBrains Mono:h10'

    -- Activating misc plugins
    require('fidget').setup {}
    require('which-key').setup {}
    require('Comment').setup {}

    -- Configure Lualine
    require('lualine').setup {
      options = {
        icons_enabled = false,
        component_separators = '|',
        section_separators = ''',
      },
    }

    -- Configure Indent Blankline
    require('ibl').setup {
      indent = { char = '┊' },
    }

    -- Configure Floaterm
    vim.cmd([[
      nnoremap <silent> <F1> <CMD>FloatermToggle<CR>
      tnoremap <silent> <F1> <C-\><C-n><CMD>FloatermToggle<CR>
    ]])

    -- Configure Gitsigns
    require('gitsigns').setup {
      signs = {
        add          = { text = '▎' },
        change       = { text = '▎' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '▎' },
        untracked    = { text = '▎' },
      }
    }

    -- Configure Telescope
    require('telescope').setup {}
    pcall(require('telescope').load_extension, 'fzf')

    do
      -- Set the keybinds
      local tsb = require('telescope.builtin')

      vim.keymap.set('n', '<leader>?'      , tsb.oldfiles   , { desc = '[?] Find recently opened files' })
      vim.keymap.set('n', '<leader><space>', tsb.buffers    , { desc = '[ ] Find existing buffers' })
      vim.keymap.set('n', '<leader>sf'     , tsb.find_files , { desc = '[SF] Search Files' })
      vim.keymap.set('n', '<leader>sF'     , tsb.git_files  , { desc = '[SF] Search Git Files' })
      vim.keymap.set('n', '<leader>sh'     , tsb.help_tags  , { desc = '[SH] Search Help' })
      vim.keymap.set('n', '<leader>sg'     , tsb.live_grep  , { desc = '[SG] Search by Grep' })
      vim.keymap.set('n', '<leader>sd'     , tsb.diagnostics, { desc = '[SD] Search Diagnostics' })
      vim.keymap.set('n', '<leader>sr'     , tsb.registers  , { desc = '[SR] Search Registers' })

      vim.keymap.set('n', '<leader>/', function()
        tsb.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })
    end

    -- Configure Neotree
    require('neo-tree').setup {
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = true,
          hide_by_name = { '.git' },
        },
        group_empty_dirs = true,
      },
      window = {
        mappings = {
          ['l'] = "open",
        },
      },
    }

    vim.cmd([[
      nnoremap <silent> <F2> <CMD>Neotree position=float toggle<CR>
      tnoremap <silent> <F2> <C-\><C-n><CMD>Neotree position=float toggle<CR>
    ]])

    -- Configure Cokeline
    require('cokeline').setup {
      default_hl = {
        fg = function(buffer)
          if buffer.is_focused then
            return get_hl_attr('ColorColumn', 'bg')
          else
            return get_hl_attr('Normal', 'fg')
          end
        end,
        bg = function(buffer)
          if buffer.is_focused then
            return get_hl_attr('Normal', 'fg')
          else
            return get_hl_attr('ColorColumn', 'bg')
          end
        end,
      },
      components = {
        {
          text = function(buffer) return ' ' .. buffer.filename .. ' ' end,
        },
      },
    }

    -- Configure Treesitter
    require('nvim-treesitter.configs').setup {
      highlight = { enable = true },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<c-space>',
          node_incremental = '<c-space>',
          scope_incremental = '<c-s>',
          node_decremental = '<M-space>',
        },
      },
    }

    -- Configure LSP
    local lspconfig = require('lspconfig')

    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('UserLspConfig', {}),
      callback = function(ev)
        local tsb = require('telescope.builtin')
        local nmap = function(keys, func, desc)
          if desc then
            desc = 'LSP: ' .. desc
          end

          vim.keymap.set('n', keys, func, { silent = true, buffer = ev.buf, desc = desc })
        end

        nmap('<leader>rn', vim.lsp.buf.rename     , '[RN] Rename')
        nmap('<leader>ca', vim.lsp.buf.code_action, '[CA] Code Action')

        nmap('gD', vim.lsp.buf.declaration   , '[GD] Goto Declaration')
        nmap('gd', vim.lsp.buf.definition    , '[GD] Goto Definition')
        nmap('gr', tsb.lsp_references        , '[GR] Goto References')
        nmap('gI', vim.lsp.buf.implementation, '[GI] Goto Implementation')

        nmap('K'    , vim.lsp.buf.hover         , 'Hover Documentation')
        nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
      end,
    })

    -- Configure Auto Complete
    local cmp = require('cmp')
    local luasnip = require('luasnip')

    luasnip.config.setup {}

    cmp.setup {
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert {
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete {},
        ['<CR>'] = cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        },
        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { 'i', 's' }),
      },
      sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
      },
    }

    -- Diagnostic keymaps
    vim.keymap.set('n', '[d'       , vim.diagnostic.goto_prev , { desc = "Go to prev diagnostic message" })
    vim.keymap.set('n', ']d'       , vim.diagnostic.goto_next , { desc = "Go to next diagnostic message" })
    vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
    vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = "Open diagnostic list" })

    -- Buffer nav keymaps
    vim.keymap.set('n', '<leader>bn', '<CMD>bn<CR>')
    vim.keymap.set('n', '<leader>bp', '<CMD>bp<CR>')
    vim.keymap.set('n', '<leader>bc', '<CMD>bd<CR>')
  '';
}
