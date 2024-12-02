-- Neovim setup, base from kickstart

-- Packer Installation if not already installed
-- ******************************************************************
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	is_bootstrap = true
	vim.fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	vim.cmd([[packadd packer.nvim]])
end

-- Packer setup
-- ******************************************************************
require("packer").startup(function(use)
	-- Package manager
	use("wbthomason/packer.nvim")

	-- LSP Configuration
	use("neovim/nvim-lspconfig")

	-- Automatically install LSPs to stdpath for neovim
	use("williamboman/mason.nvim")
	use("williamboman/mason-lspconfig.nvim")

	-- Completion
	use("hrsh7th/nvim-cmp")
	use("hrsh7th/cmp-nvim-lsp")

	-- Highlight, edit, and navigate code
	use({
		"nvim-treesitter/nvim-treesitter",
		run = function()
			pcall(require("nvim-treesitter.install").update({ with_sync = true }))
		end,
	})

	-- Additional text objects via treesitter
	use({
		"nvim-treesitter/nvim-treesitter-textobjects",
		after = "nvim-treesitter",
	})

	use("simrat39/symbols-outline.nvim")

	-- VCS related plugins
	use("mhinz/vim-signify")
	use("jackysee/telescope-hg.nvim")

	-- Commenting and Tabstops
	use("numToStr/Comment.nvim")
	use("tpope/vim-sleuth")

	-- Fuzzy Finder (files, lsp, etc)
	use({
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		requires = { "nvim-lua/plenary.nvim" },
	})

	-- Fuzzy Finder Algorithm which requires local dependencies to be built.
	-- Only load if `make` is available
	use({
		"nvim-telescope/telescope-fzf-native.nvim",
		run = "make",
		cond = vim.fn.executable("make") == 1,
	})

	-- Debugging Adapters
	use({ "mfussenegger/nvim-dap", requires = { "nvim-neotest/nvim-nio" } })
	use({ "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } })

	-- Snippets
	use("L3MON4D3/LuaSnip")
	use("saadparwaiz1/cmp_luasnip")

	-- Visual stuff
	use("Mofiqul/vscode.nvim")
	use("nvim-lualine/lualine.nvim")
	use("lukas-reineke/indent-blankline.nvim")
	use({
		"akinsho/bufferline.nvim",
		requires = "nvim-tree/nvim-web-devicons",
	})
	use({
		"linrongbin16/lsp-progress.nvim",
		requires = { "nvim-tree/nvim-web-devicons" },
	})

	-- File Browser
	use({
		"nvim-tree/nvim-tree.lua",
		requires = {
			"nvim-tree/nvim-web-devicons",
		},
		tag = "nightly",
	})

	-- Formatter
	use("mhartington/formatter.nvim")

	-- Language specific
	--
	-- Lua/nvim
	use("folke/neodev.nvim")

	-- Golang
	use("ray-x/go.nvim")
	use("leoluz/nvim-dap-go")

	-- Python
	use("mfussenegger/nvim-dap-python")

	if is_bootstrap then
		require("packer").sync()
	end
end)

-- When we are bootstrapping a configuration, it doesn't
-- make sense to execute the rest of the init.lua.
--
-- You'll need to restart nvim, and then it will work.
if is_bootstrap then
	print("==================================")
	print("    Plugins are being installed")
	print("    Wait until Packer completes,")
	print("       then restart nvim")
	print("==================================")
	return
end

-- Automatically source and re-compile packer whenever you save this init.lua
local packer_group = vim.api.nvim_create_augroup("Packer", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
	command = "source <afile> | silent! LspStop | silent! LspStart | PackerCompile",
	group = packer_group,
	pattern = vim.fn.expand("$MYVIMRC"),
})

-- Setting options
-- ******************************************************************
vim.o.swapfile = false

-- Set highlight on search
vim.o.hlsearch = false

-- Line numbering
vim.wo.number = true

-- Cursor control, keep near center
vim.wo.scrolloff = 10

-- Color Column
vim.o.colorcolumn = "80"

-- Cursor
vim.o.cursorline = true
vim.o.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,a:blinkwait800-blinkoff400-blinkon250"

-- Enable mouse mode
vim.o.mouse = "a"

-- Enable break indent
vim.o.breakindent = true

-- Undo
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = "yes"

-- Set colorscheme
vim.o.termguicolors = true

-- Set tabstop
vim.o.tabstop = 4
vim.o.wrap = false

-- Setup folding
vim.o.foldmethod = "indent"
vim.o.foldlevelstart = 99

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

-- Basic Keymaps
-- ******************************************************************
-- Set <space> as the leader key
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- See `:help vim.keymap.set()`
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Alt Up/Down line moves
vim.keymap.set("i", "<A-Down>", "<Esc>:m .+1<CR>==gi")
vim.keymap.set("i", "<A-Up>", "<Esc>:m .-2<CR>==gi")
vim.keymap.set("n", "<A-Down>", ":m .+1<CR>==")
vim.keymap.set("n", "<A-Up>", ":m .-2<CR>==")
vim.keymap.set("v", "<A-Down>", ":m '>+1<CR>gv==gv")
vim.keymap.set("v", "<A-Up>", ":m '<-2<CR>gv==gv")

-- Buffer/Window forward/back
vim.keymap.set("n", "<A-Left>", ":bp<CR>", { silent = true })
vim.keymap.set("n", "<A-Right>", ":bn<CR>", { silent = true })
vim.keymap.set("n", "<A-h>", ":bp<CR>", { silent = true })
vim.keymap.set("n", "<A-l>", ":bn<CR>", { silent = true })

-- ******************************************************************
-- Languages Setup
-- ******************************************************************

-- Setup neovim lua configuration
require("neodev").setup()

-- Setup go support
require("go").setup()
require("dap-go").setup()
vim.keymap.set("n", "<Leader>dt", require("dap-go").debug_test, { silent = true })

-- Setup Python Support
require("dap-python").setup("~/.local/share/nvim/mason/packages/debugpy/venv/bin/python")
vim.keymap.set("n", "<Leader>dm", require("dap-python").test_method, { silent = true })
vim.keymap.set("n", "<Leader>dc", require("dap-python").test_class, { silent = true })

-- ******************************************************************
-- Plugin Setup
-- ******************************************************************

-- Setup my colors
local mycolor = "vscode"
require("vscode").setup()
vim.cmd("colorscheme " .. mycolor)

-- File Browser setup
-- ******************************************************************
require("nvim-tree").setup({
	sort_by = "case_sensitive",
	sync_root_with_cwd = true,
	renderer = {
		group_empty = true,
	},
	git = { ignore = false },
})
vim.keymap.set("n", "<F4>", require("nvim-tree").toggle, { desc = "Tree Toggle" })

-- Debug setup
-- ******************************************************************
require("dapui").setup({
	layouts = {
		{
			elements = {
				{
					id = "breakpoints",
					size = 0.25,
				},
				{
					id = "scopes",
					size = 0.75,
				},
			},
			position = "left",
			size = 40,
		},
		{
			elements = { {
				id = "repl",
				size = 1.0,
			} },
			position = "right",
			size = 30,
		},
	},
})
local dap, dapui = require("dap"), require("dapui")
dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end

vim.fn.sign_define("DapBreakpoint", { text = "🟥", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "▶️", texthl = "", linehl = "", numhl = "" })

-- Debug Adapter Keymaps
vim.keymap.set("n", "<F5>", require("dap").continue, { desc = "Debug: Resume", silent = true })
vim.keymap.set("n", "<F6>", require("dap").step_over, { desc = "Debug: Step Over", silent = true })
vim.keymap.set("n", "<F7>", require("dap").step_into, { desc = "Debug: Step Into", silent = true })
vim.keymap.set("n", "<F8>", require("dap").step_out, { desc = "Debug: Step Out", silent = true })

-- Symbol Browser
-- ******************************************************************
require("symbols-outline").setup({
	autofold_depth = 0,
})
vim.keymap.set("n", "<F9>", ":SymbolsOutline<CR>", { desc = "Symbols Toggle", silent = true })
vim.keymap.set("n", "<Leader>b", require("dap").toggle_breakpoint, { desc = "Debug: Set Breakpoint", silent = true })

-- Setup our bufferline
-- ******************************************************************
require("bufferline").setup()

-- Set lualine as statusline
-- ******************************************************************
require("lualine").setup({
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "filename" },
		lualine_c = {
			require("lsp-progress").progress,
		},
	},
	options = {
		theme = mycolor,
		component_separators = "|",
		section_separators = "",
	},
})

-- Enable Progress line into lualine
require("lsp-progress").setup({})
vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
vim.api.nvim_create_autocmd("User", {
	group = "lualine_augroup",
	pattern = "LspProgressStatusUpdated",
	callback = require("lualine").refresh,
})

-- Enable Comment.nvim
-- ******************************************************************
require("Comment").setup()

-- Enable `lukas-reineke/indent-blankline.nvim`
-- ******************************************************************
require("ibl").setup()

-- HG telescope search
-- ******************************************************************
require("telescope").load_extension("hg")

-- Configure Telescope
-- ******************************************************************
require("telescope").setup({
	defaults = {
		mappings = {
			i = {
				["<C-u>"] = false,
				["<C-d>"] = false,
			},
		},
	},
})

-- Enable telescope fzf native, if installed
pcall(require("telescope").load_extension, "fzf")

vim.keymap.set("n", "<leader>?", require("telescope.builtin").oldfiles, { desc = "[?] Find recently opened files" })
vim.keymap.set("n", "<leader><space>", function()
	-- You can pass additional configuration to telescope to change theme, layout, etc.
	require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
		winblend = 10,
		previewer = false,
	}))
end, { desc = "[/] Fuzzily search in current buffer]" })
vim.keymap.set("n", "<leader>sf", require("telescope.builtin").find_files, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>sh", require("telescope.builtin").help_tags, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>sw", require("telescope.builtin").grep_string, { desc = "[S]earch current [W]ord" })
vim.keymap.set("n", "<leader>sg", require("telescope.builtin").live_grep, { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<leader>sd", require("telescope.builtin").diagnostics, { desc = "[S]earch [D]iagnostics" })
vim.keymap.set("n", "<leader>sk", require("telescope.builtin").keymaps, { desc = "[S]earch [K]eymaps" })

vim.keymap.set("n", "<leader>hf", require("telescope._extensions.hg_builtins").files, { desc = "[H]G [F]iles" })
vim.keymap.set("n", "<leader>hs", require("telescope._extensions.hg_builtins").status, { desc = "[H]G [S]tatus" })

-- Configure Treesitter
-- ******************************************************************
require("nvim-treesitter.configs").setup({
	-- Add languages to be installed here that you want installed for treesitter
	ensure_installed = {
		"c",
		"cpp",
		"go",
		"vimdoc",
		"lua",
		"python",
		"rust",
		"typescript",
		"vim",
	},

	highlight = { enable = true },
	indent = { enable = true, disable = { "python" } },
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "<c-space>",
			node_incremental = "<c-space>",
			scope_incremental = "<c-s>",
			node_decremental = "<c-backspace>",
		},
	},
})

-- LSP settings.
-- ******************************************************************
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
	local nmap = function(keys, func, desc)
		if desc then
			desc = "LSP: " .. desc
		end

		vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
	end

	nmap("<F2>", vim.lsp.buf.rename, "[R]e[n]ame")
	nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
	nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
	nmap("<leader>gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
	nmap("<leader>gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
	nmap("<leader>gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
	nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
	nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
	nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

	-- See `:help K` for why this keymap
	nmap("K", vim.lsp.buf.hover, "Hover Documentation")
	nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

	-- Create a command `:Format` local to the LSP buffer
	vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
		vim.lsp.buf.format()
	end, { desc = "Format current buffer with LSP" })
end

-- Enable the following language servers
local servers = {
	clangd = {},
	gopls = {},
	lua_ls = {
		Lua = {
			workspace = { checkThirdParty = false },
			telemetry = { enable = false },
			diagnostics = {
				disable = { "missing-fields" },
			},
		},
	},
	pyright = {},
	rust_analyzer = {},
}

-- nvim-cmp supports additional completion capabilities, broadcast to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- Setup mason so it can manage external tooling
require("mason").setup()

-- Ensure the servers above are installed
local mason_lspconfig = require("mason-lspconfig")

mason_lspconfig.setup({
	ensure_installed = vim.tbl_keys(servers),
})

mason_lspconfig.setup_handlers({
	function(server_name)
		require("lspconfig")[server_name].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			settings = servers[server_name],
		})
	end,
})

-- nvim-cmp setup
-- ******************************************************************
local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete({}),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
	}),
	sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
	},
})

-- Formatting setup
-- ******************************************************************
require("formatter").setup({
	logging = true,
	log_level = vim.log.levels.WARN,
	filetype = {
		c = { require("formatter.filetypes.c").clangformat },
		go = { require("formatter.filetypes.go").goimports },
		html = { require("formatter.filetypes.html").prettier },
		javascript = { require("formatter.filetypes.javascript").prettier },
		lua = { require("formatter.filetypes.lua").stylua },
		python = { require("formatter.filetypes.python").black },
		rust = { require("formatter.filetypes.rust").rustfmt },
		["*"] = {
			require("formatter.filetypes.any").remove_trailing_whitespace,
		},
	},
})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	pattern = "*",
	callback = function()
		vim.cmd([[FormatWrite]])
	end,
})
