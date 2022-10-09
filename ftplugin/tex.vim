set spell spelllang=en_gb
set textwidth=120

let s:project_name =  FindProjectRoot(g:tx_projects_dir)
let s:current_project = g:tx_projects_dir . s:project_name

function! Compile()

python3 << EPY
import vim
import os
import texoutparse

project = vim.eval('s:current_project')
file_name = [f for f in os.listdir(project) if f.endswith('.tex')][0]
file = os.path.join(project, file_name)

log_dir = os.path.join(project, 'logs')
build_dir = os.path.join(project, 'build')
os.makedirs(log_dir, exist_ok=True)

compilation_file = f'{log_dir}/compilation.log'
warning_file = f'{log_dir}/warnings.log'
error_file = f'{log_dir}/errors.log'
badbox_file = f'{log_dir}/badboxes.log'

command = f'xelatex -synctex=1 -interaction=nonstopmode -output-directory={build_dir} {file}'
os.system(' '.join([command, '>', compilation_file]))

parser = texoutparse.LatexLogParser()

# We are supposed to have only one tex file in the main package
# Enhance code to take into account a special name that is set in a project config file
with open(compilation_file) as log_file:
    parser.process(log_file)

with open(warning_file, 'w') as log_file:
    log_file.write('\n'.join(map(str, parser.warnings)))

with open(error_file, 'w') as log_file:
    log_file.write('\n'.join(map(str, parser.errors)))

with open(badbox_file, 'w') as log_file:
    log_file.write('\n'.join(map(str, parser.badboxes)))

print(parser)
EPY
endfunction

function! OpenPdf()
python3 << EPY
import vim
import os
project = vim.eval('s:current_project')
file_name = [f for f in os.listdir(project) if f.endswith('.tex')][0]
file = os.path.join(project, 'build', file_name.replace('.tex', '.pdf'))
command = f'evince --fullscreen {file} &'
os.system(command)
EPY
redraw!
endfunction

nnoremap <leader>\o :call OpenPdf()<CR>
nnoremap <leader>\c :call Compile()<CR>
