function! tabdrop#tabdrop(path,...)
    let l:path = a:path
    if len(l:path)>0
        let l:path = fnamemodify(l:path, ":p")
    else
        tabnew
        return
    endif

    let l:bufnr = bufnr(l:path)
    if l:bufnr>0
        let l:win_ids = win_findbuf(l:bufnr)
        echo l:win_ids
        if len(l:win_ids)>0
            call win_gotoid(l:win_ids[0])
        else
            exec "tabedit " . l:path
        endif
    else
        exec "tabedit " . l:path
    endif

    if a:0>0
        exec 'normal! '.a:1.'G'
    endif
    if a:0>1
        exec 'normal! '.a:2.'|'
    endif
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

    for t in range(1, tabpagenr('$'))
        for b in tabpagebuflist(t)
            if fnamemodify(bufname(b), ":p") == l:path
                if eval('g:tabdrop_close_on_poptag') == 1 && t!=tabpagenr()
                    close
                endif
                exec "tabnext " . t
                exec "normal! ".l:line."G"
                exec "normal! ".l:col."|"
                return
            endif
        endfor
    endfor
endfunction
