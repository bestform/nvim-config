local test_list_cache = nil
local run_vitests = function(name, path)
  local buf_id = vim.api.nvim_create_buf(false, true)
  local win_id = -1
  local chan_id = -1
  local handle_exit = function(_, code, _)
    if code == 0 then
      vim.notify("Vitest finished successfully", vim.log.levels.INFO)
    else
      vim.notify("Vitest finished with errors", vim.log.levels.ERROR)
    end
  end

  local handle_stdout = function(_, data, _)
    if not data or #data == 0 then
      return
    end

    if chan_id == -1 then
      -- We need to open the terminal channel after the window has been created.
      -- This is why we do it here in the handler
      chan_id = vim.api.nvim_open_term(buf_id, {})
    end

    -- We send on the terminal channel to be able to render the terminal colors
    -- If we used `vim.api.nvim_buf_set_lines`, the colors would not be rendered correctly
    local content = table.concat(data, "\n")
    vim.api.nvim_chan_send(chan_id, content)
    local bufinfo = vim.fn.getbufinfo(buf_id)
    if win_id ~= -1 then
      vim.api.nvim_win_set_cursor(win_id, { bufinfo[1].linecount, 0 })
    end
  end

  -- spawn new window
  local conf = vim.api.nvim_win_get_config(0)
  local width = conf.width or 80
  local height = conf.height or 80
  local filenamepart = ""
  if path then
    filenamepart = path
  end

  win_id = vim.api.nvim_open_win(buf_id, true, {
    relative = "win",
    row = 1,
    col = 3,
    width = width - 6,
    height = height - 3,
    border = "rounded",
    style = "minimal",
    title = "vitest",
    title_pos = "center",
  })

  -- run tests
  vim.fn.jobstart(
    "npm run test -- " .. filenamepart .. ' --hideSkippedTests --passWithNoTests --coverage false -t "' .. name .. '"',
    {
      cwd = vim.fn.getcwd(-1, -1),
      pty = true,
      on_stdout = handle_stdout,
      on_exit = handle_exit,
    }
  )
end

local fzf = require("fzf-lua")
local last_test = ""
local function vitest_fzf_picker()
  local promptName = "Vitest (cached) > "
  local entries = {}
  table.insert(entries, "ALL")
  local jsonlist = test_list_cache
  if jsonlist == nil then
    jsonlist = vim
      .system({ "npm", "run", "list" }, {
        cwd = vim.fn.getcwd(-1, -1),
      })
      :wait()
    promptName = "Vitest > "
    test_list_cache = jsonlist
  end
  local parts = string.gmatch(jsonlist.stdout, "{[^}]*}")
  for k, _ in parts do
    local test = vim.json.decode(k)
    local testname = test.name
    local testpath = test.file
    local entry = string.format("%s\t%s", testname, testpath)
    if testname == last_test then
      table.insert(entries, 1, entry)
    else
      table.insert(entries, entry)
    end
  end
  fzf.fzf_exec(entries, {
    prompt = promptName,
    fzf_opts = {
      ["--delimiter"] = "\t",
      ["--with-nth"] = "1",
    },
    actions = {
      ["default"] = function(selected)
        local sel_parts = vim.split(selected[1], "\t")
        last_test = sel_parts[1]
        local name, _ = sel_parts[1]:gsub(" >", "")
        if name == "ALL" then
          run_vitests("")
        else
          run_vitests("^" .. name .. "$", sel_parts[2])
        end
      end,
    },
  })
end

vim.keymap.set("n", "<leader>tt", function()
  vitest_fzf_picker()
end, { desc = "Run Vitest" })
vim.keymap.set("n", "<leader>tc", function()
  test_list_cache = nil
end, { desc = "Clear Test List Cache" })
