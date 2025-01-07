### treeparser.sh -> parses an LLM directory tree response and creates the corresponding directories and files
### copyintollm.sh -> walks the specified directories, generating a directory tree and copying into clipboard
  - pauses for a prompt
  - type '1' to enable file copying -> parses the files specified and copies into clipboard after the directory tree
  - type '0' or anything else to disable file copying

### nvim 
  - init.lua -> links all the files
  - lua/core -> folder containing the rest of the config files
  - lua/core/colorscheme.lua -> catcuppin theme
  - lua/core/keymaps.lua -> specific keymaps for extensions
  - lua/core/options.lua -> customizable options like tabwidth, cursor visualization, etc.
  - lua/core/plugins.lua -> all plugins managed by Lazy package manager
