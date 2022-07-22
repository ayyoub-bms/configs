set spell spelllang=en_gb
set textwidth=79
set expandtab

augroup PY_TAGS
    autocmd!
    autocmd BufWritePost * call GetTags(g:py_projects_dir) |  call SaveTags(g:py_projects_dir) | redraw!
augroup END
