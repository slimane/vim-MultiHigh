command! -nargs=+ MultiHighLightNext       : call MultiHigh#MultiHigh#Apply("<args>")
\                                           | execute '/' . "<args>"
command! -nargs=+ MultiHighLightPrevious   : call MultiHigh#MultiHigh#Apply("<args>")
\                                           | execute '?' . "<args>"

command! -nargs=0 MultiHighLightClear : call MultiHigh#MultiHigh#Clear()


if !exists('g:MultiHigh_default_mapping_disable')
\       || g:MultiHigh_default_mapping_disable == 1
    nnoremap    <Leader>/   :MultiHighLightNext<space>
    nnoremap    <Leader>?   :MultiHighLightPrevious<space>
endif

