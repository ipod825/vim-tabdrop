function! tabdrop#newtabdrop(...)
    let l:num_tabpages = tabpagenr()
    if l:num_tabpages>1
        tabclose
        call call(function("tabdrop#tabdrop"), a:000)
    else
        call call(function("tabdrop#tabdrop"), a:000)
        if tabpagenr() > 1
            tabclose 1
        endif
    endif
endfunction

function! tabdrop#tagtabdrop(...) abort
    let l:orig_target=expand('%:p')
    let l:orig_line = line('.')
    let l:orig_col = col('.')

    let l:candidate = map(taglist(expand('<cword>')), "v:val['filename']")
    let l:extra_candidate = filter(l:candidate, "v:val != '".l:candidate[0]."'")

    " if all the target is in the same file, possibly there are duplicate tags.
    if len(l:extra_candidate) > 0
        execute 'tab tjump '.expand('<cword>')
    else
        execute 'tab tag '.expand('<cword>')
    endif
    let l:target=expand('%:p')
    let l:line = line('.')
    let l:col = col('.')

    if l:orig_target == l:target && l:orig_line == l:line && l:orig_col == l:col
        return
    endif
    quit
    call tabdrop#tabdrop(l:target, l:line, l:col)
    call feedkeys("\<esc>")
endfunction

function! tabdrop#tabdrop(...)
    if a:0 ==0
        tabedit
        return
    endif

    let l:path = a:1
    if len(l:path)>0
        let l:path = fnamemodify(l:path, ":p")
    else
        tabnew
        return
    endif
    if isdirectory(l:path)
        exe 'tabedit '.l:path
        return
    endif

    let l:bufnr = bufnr(l:path)
    if l:bufnr>0
        let l:win_ids = win_findbuf(l:bufnr)
        if len(l:win_ids)>0
            call win_gotoid(l:win_ids[0])
        else
            exec "tabedit " . l:path
        endif
    else
        exec "tabedit " . l:path
    endif

    if a:0>1
        exec 'normal! '.a:2.'G'
    endif
    if a:0>2
        exec 'normal! '.a:3.'|'
    endif
endfunction

function! tabdrop#qftabdrop()
    redir @">
    file
    redir END
    let l:entry=""
    if @"=~'Quickfix List'
        let l:entry = getqflist()[line(".")-1]
    elseif @"=~"Location List"
        let l:entry = getloclist(win_getid())[line(".")-1]
    else
        echoerr "QfTabdrop only works in quickfix list."
        return
    endif
    quit
    execute "Tabdrop ".bufname(l:entry.bufnr)
    exec "normal! ".l:entry.lnum."G"
    exec "normal! ".l:entry.col."|"
endfunction

let s:tags = []
function! tabdrop#push_tag()
    call add(s:tags, [expand('%:p'), line('.'), col('.')])
endfunction

function! tabdrop#pop_tag()
    if len(s:tags) == 0
        return
    endif

    let l:pos = s:tags[-1]
    let s:tags = s:tags[:-2]
    let l:path = l:pos[0]
    let l:line = l:pos[1]
    let l:col = l:pos[2]

    if eval('g:tabdrop_close_on_poptag') == 1
        " unhandeled corner case: only one tab with one window is left
        close
    endif

    let l:bufnr = bufnr(l:path)
    if l:bufnr>0
        let l:win_ids = win_findbuf(l:bufnr)
        if len(l:win_ids)>0
            call win_gotoid(l:win_ids[0])
        else
            exec "tabedit " . l:path
        endif
    else
        exec "tabedit " . l:path
    endif
    exec "normal! ".l:line."G"
    exec "normal! ".l:col."|"
endfunction
