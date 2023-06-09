return {
  {
    "epwalsh/obsidian.nvim",
    config = function()
      require("obsidian").setup({
        dir = "~/synology_shared/obsidian/brain",
        -- use_advanced_uri = true,
        daily_notes = {
          folder = "dailies",
        },
        completion = {
          nvim_cmp = true, -- if using nvim-cmp, otherwise set to false
        },
        note_id_func = function(title)
          -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
          local suffix = ""
          if title ~= nil then
            -- If title is given, transform it into valid file name.
            suffix = title:gsub(" ", "_"):gsub("[^A-Za-z0-9_]", ""):lower()
          else
            -- If title is nil, just add 4 random uppercase letters to the suffix.
            for _ = 1, 4 do
              suffix = suffix .. string.char(math.random(65, 90))
            end
          end
          -- return tostring(os.time()) .. "_" .. suffix
          return suffix
        end,
      })
    end,
  },
}
