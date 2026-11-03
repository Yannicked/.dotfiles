return {
	{
		"ellisonleao/gruvbox.nvim",
		priority = 1000, -- load before everything else
		config = function()
			require("gruvbox").setup()
			vim.o.background = "dark"
			vim.cmd.colorscheme("gruvbox")
		end,
	},

	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			spec = {
				{ "<leader>s", group = "search" },
				{ "<leader>g", group = "git" },
				{ "<leader>c", group = "code" },
			},
		},
	},

	{
		"nvim-mini/mini.statusline",
		opts = { use_icons = false },
	},
}
