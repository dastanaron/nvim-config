# NeoVim Configuration with NvChad for Typescript and Golang

## Overview

This repository contains a customized NeoVim configuration built on top of [NvChad](https://github.com/NvChad/NvChad), a highly optimized and feature-rich NeoVim configuration framework. The setup is specifically tailored for developers working with **Typescript** and **Golang**, providing a seamless and efficient coding experience.

## Features

- **NvChad Base Configuration**: Leverages NvChad's pre-configured settings for a fast and modern NeoVim experience.
- **Typescript Support**:
  - Syntax highlighting and autocompletion for Typescript.
  - Integration with LSP (Language Server Protocol) for Typescript.
  - Debugging support for Typescript projects.
- **Golang Support**:
  - Syntax highlighting and autocompletion for Golang.
  - Integration with LSP for Golang.
  - Debugging support for Golang projects.
- **Custom Keybindings**: Additional keybindings for common tasks in Typescript and Golang development.
- **Custom Buffer Panel**: If you have many tabs with buffers press <leader>pb
- **Plugins**: Includes a curated list of plugins to enhance productivity and functionality.
- **DAP**: Installed and configured dap for debugging nodejs in docker

## Prerequisites

Before setting up this configuration, ensure you have the following installed:

- [NeoVim](https://neovim.io/) (v0.8.0 or higher)
- [Node.js](https://nodejs.org/) (for Typescript LSP and tools)
- [Go](https://golang.org/) (for Golang development)
- [NvChad](https://github.com/NvChad/NvChad) (installed and set up)

## Installation

1. **Clone this Repository**:

   ```bash
   git clone https://github.com/dastanaron/nvim-config.git ~/.config/nvim
   ```
2. **Run Nvim**

3. **Install plugins**

Plugins will be installed automatically after launching NVIM, but if this does not happen, enter `:Lazy`

## Custom Keybindings

  - `<leader>lf`: Open floating diagnostic.
  - `<A-i>`: Terminal toggle floating tert.
  - `<leader>gb`: Git blame.

[...more](./lua/mappings.lua)

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

Happy coding with NeoVim and NvChad! 🚀
