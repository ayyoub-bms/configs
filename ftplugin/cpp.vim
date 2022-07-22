set spell spelllang=en_gb
set textwidth=120

augroup CPP_TAGS
    autocmd!
    autocmd BufWritePost * call GetTags(g:cpp_projects_dir) |  call SaveTags(g:cpp_projects_dir) | redraw!
augroup END
