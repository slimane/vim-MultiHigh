if exists('g:MultiHigh_loaded')
    finish
endif




let s:save_cpo = &cpo
set cpo&vim




let s:color = exists('g:multi_highlight_colors')
\                               ? g:multi_highlight_colors
\                               : [
\                                  'magenta'
\                                   , 'cyan'
\                                   , 'blue'
\                                   , 'green'
\                                   , 'red'
\                               ]

function! s:initCounter()
    let b:counter = 0
endfunction




function! MultiHigh#MultiHigh#Apply(searchKey)
    if !exists('b:counter') || len(s:color) <= b:counter
        call s:initCounter()
    endif

    let highGroupName = s:createGroupName(b:counter)

    call s:clearHighlight(highGroupName)

    execute 'highlight ' . highGroupName .  ' guibg='   . s:color[b:counter]
    \                                    .  ' ctermbg=' . s:color[b:counter]

    if !exists('b:matchId')
        let b:matchId = {}
    endif
    let b:matchId[highGroupName] = matchadd(highGroupName, s:createSmartPat(a:searchKey))

    let b:counter += 1
endfunction


function! MultiHigh#MultiHigh#Clear()
    for i in range(0, len(s:color))
        call s:clearHighlight(s:createGroupName(i))
    endfor
    call s:initCounter()
endfunction




function! s:createGroupName(num)
    return 'MultiHighLight' . '_BufferNo' . bufnr('%') . '_ColorNo' . a:num
endfunction

function! s:clearHighlight(groupName)
    if exists('b:matchId') 
    \       && has_key(b:matchId, a:groupName)
        call matchdelete(b:matchId[a:groupName])
        call remove(b:matchId, a:groupName)
    endif

    execute 'highlight clear ' . a:groupName
endfunction

function! s:echoErrMsg(excepction)
    echohl ErrorMsg
    echomsg matchstr(a:excepction, '^\C[^E]\+\zs.*\ze$')
    echohl NONE
endfunction

" TODO \D, \Wとかにも対応させる
function! s:createSmartPat(pat)
    if !&ignorecase
        return '\C' . a:pat
    elseif match(a:pat, '\C[A-Z]') != -1
    \       && &ignorecase 
    \       && &smartcase
        return '\C' . a:pat
    else
        return '\c' . a:pat
    endif
endfunction




let &cpo = s:save_cpo
let g:MultiHigh_loaded = 1
