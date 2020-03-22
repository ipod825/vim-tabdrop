if exists('g:loaded_tabdrop') || &cp
    finish
endif
let g:loaded_tabdrop = 1

let s:save_cpo = &cpo
set cpo&vim

command! -nargs=* -complete=file Tabdrop exec 'call tabdrop#tabdrop(<f-args>)'
command! -nargs=* -complete=file NewTabdrop exec 'call tabdrop#newtabdrop(<f-args>)'

command! TabdropPushTag exec 'call tabdrop#push_tag()'
command! TabdropPopTag exec 'call tabdrop#pop_tag()'

let g:tabdrop_close_on_poptag = get(g:, 'tabdrop_close_on_poptag', 1)

let &cpo = s:save_cpo
