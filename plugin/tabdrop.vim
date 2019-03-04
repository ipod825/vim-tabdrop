if exists('g:loaded_tabdrop') || &cp
    finish
endif
let g:loaded_tabdrop = 1

let s:save_cpo = &cpo
set cpo&vim

exec "python3 from tabdrop.tabdrop import tabdrop, tabdrop_push_tag, tabdrop_pop_tag"
command! -nargs=1 -complete=file Tabdrop exec 'python3 tabdrop("'.fnamemodify("<args>", ":p").'")'
command! TabdropPushTag exec 'python3 tabdrop_push_tag()'
command! TabdropPopTag exec 'python3 tabdrop_pop_tag()'

let g:tabdrop_close_on_poptag = get(g:, 'tabdrop_close_on_poptag', 1)

let &cpo = s:save_cpo
