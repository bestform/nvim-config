return {
  "mfussenegger/nvim-dap",
  config = function()
    local dap = require("dap")

    dap.set_log_level("trace")

    dap.adapters.php = {
      type = "executable",
      command = "node",
      args = { "/Users/mderer/workfolder/vscode-php-debug/out/phpDebug.js" },
    }

    dap.configurations.php = {
      {
        type = "php",
        request = "launch",
        name = "Listen for Xdebug",
        port = 9003,
        pathMappings = {
          -- TODO: use cwd here
          ["/usr/local/apache2/htdocs/customer/"] = "/Users/mderer/wwwusers/chameleon/master/customer/",
        },
      },
    }
  end,
}
