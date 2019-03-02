if exists('g:loaded_tabdrop') || &cp
    finish
endif
let g:loaded_tabdrop = 1

let s:save_cpo = &cpo
set cpo&vim

exec "python3 from tabdrop.tabdrop import tabdrop"
exec "python3 from tabdrop.tabdrop import back_to_last_tab"
command! -nargs=1 -complete=file Tabdrop exec 'python3 tabdrop("'.fnamemodify("<args>", ":p").'")'

let g:tabdrop_close_on_back = get(g:, 'tabdrop_close_on_back', 1)
nnoremap <silent><Plug>(TabdropBack) :exec 'python3 back_to_last_tab()'<Cr>

let &cpo = s:save_cpo
