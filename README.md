## vim-tabdrop

### Installation
Install either with [vim-plug](https://github.com/junegunn/vim-plug), [Vundle](https://github.com/gmarik/vundle), [Pathogen](https://github.com/tpope/vim-pathogen) or [Neobundle](https://github.com/Shougo/neobundle.vim).

### Usage
This plugin provides enhanced version of the built-in `:tab drop` command (if the file is already open in a tab then vim will switch to that tab instead of opening a new window). You can:
1. Run `:Tabdrop path_to_open [line#], [col#]` to open specified path. Pass the optional line and column number if you want to jump to certain line and column.
2. Run `:NewTabdrop path_to_open [line#], [col#]` to perform exact the thing as `Tabdrop` except that the content in the current tab will always be hidden after drop. This might be useful for e.g. in [vim-esearch](https://github.com/eugen0329/vim-esearch).
3. Run `:TabdropPushTag` to save the current location in a stack
4. Run `:TabdropPopTag` to jump back to the last location
5. Run `:TagTabdrop` to follow tags of word-under-cursor in a new/existing tabpage.

For example, if you use [LanguageClient-neovim](https://github.com/autozimu/LanguageClient-neovim) to do code traversal, having the following config in your vimrc you can jump to function definition in a new (or existing) tab by pressing `Ctrl+]` and jump back by pressing `Ctrl-t`.

```vim
nnoremap <C-]> :call Gotodef()<CR>
nmap <C-t> :TabdropPopTag<Cr>

function! Gotodef()
    TabdropPushTag
    call LanguageClient_textDocument_definition({'gotoCmd': 'Tabdrop'})
endfunction
```

To have a unified mapping for both a language server and tags file. You can define the `Gotodef` function as:
```vim
function! Gotodef()
    TabdropPushTag
    try
        TagTabdrop
    catch /E433:/
        call LanguageClient_textDocument_definition({'gotoCmd': 'Tabdrop'})
    endtry
endfunction
```
Note that `TagTabdrop` uses `tjump` internally, so vim will prompt a menu for you to select if there are multiple tag matches.

### Customization
By default, if the target tab is different than the current tab, vim-tabdrop close the current tab on `TabdropPopTag` command. To prevent from this, add the following snippet in your vimrc

```vim
let g:tabdrop_close_on_poptag=0
```
