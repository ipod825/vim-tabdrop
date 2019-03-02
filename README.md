## vim-tabdrop

### Installation
Install either with [vim-plug](https://github.com/junegunn/vim-plug), [Vundle](https://github.com/gmarik/vundle), [Pathogen](https://github.com/tpope/vim-pathogen) or [Neobundle](https://github.com/Shougo/neobundle.vim).

### Usage
This plugin provides enhanced version of the built-in `:tab drop` command (if the file is already open in a tab then vim will switch to that tab instead of opening a new window). You can:
1. Run `:Tabdrop path_to_open` to open specified path
2. In the buffer of `path_to_open`, the mapping `<Plug>(TabdropBack)` leads you back to where you were

The benefit of the second point is that it mimics the built-in `:tag` function. For example, if you use [LanguageClient-neovim](https://github.com/autozimu/LanguageClient-neovim) to do code traversal, having the following config in your vimrc makes you traverse code just like using ctags (but without really generating the tag file).

```vim
nnoremap <C-]> :call LanguageClient_textDocument_definition({'gotoCmd': 'Tabdrop'})<CR>
nmap <C-t> <Plug>(TabdropBack)
```

### Customization
By default, vim-tabdrop close the current tab on `<Plug>(TabdropBack)` mapping. To prevent from this, add the following snippet in your vimrc

```vim
let g:tabdrop_close_on_back=0
```
