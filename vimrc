
"execute pathogen#infect('bundle/{}', '~/src/vim/bundle/{}')
execute pathogen#infect()
syntax on
filetype plugin indent on



" cscope related
set nocscopeverbose  

set mouse=ar
set ttymouse=sgr
set hlsearch
colorscheme desert
set smartindent
set expandtab
set shiftwidth=2
set tabstop=2
set autoindent

syntax on
set hlsearch
set showmatch

set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936
set termencoding=utf-8
set encoding=utf-8

set cscopetag
set textwidth=80
set colorcolumn=80

set foldmethod=indent
set foldlevel=99
" Enable folding with the spacebar
nnoremap <space> za


"set cursorline
"set cursorcolumn


let Tlist_Auto_Open = 0
let Tlist_Auto_Update = 0

set cscopetag
set textwidth=80


set nocompatible
set t_Co=256

set wildmenu
set wildmode=longest:list,full

set completeopt=longest,menu,preview
set backspace=indent,eol,start

set history=200

set laststatus=2
set showcmd
set incsearch
set splitright
set splitbelow

"Python
let OPTION_NAME = 1
let python_highlight_all = 1
au FileType python set expandtab shiftwidth=4 tabstop=4


" OpenCL format.
autocmd BufNewFile,BufRead *.cl set filetype=opencl
autocmd FileType opencl source /search/speech/luxingjing/.vim/plugin/opencl.vim
autocmd BufNewFile,BufRead *.cc set filetype=cpp
autocmd BufNewFile,BufRead *.cpp set filetype=cpp
autocmd BufNewFile,BufRead *.metal set filetype=cpp
autocmd BufNewFile,BufRead *.mm set filetype=cpp
autocmd BufNewFile,BufRead *.m set filetype=cpp

"NerdTree
nnoremap <silent> <F3> :NERDTree <CR>

"TagbarToggle
nnoremap <silent> <F2> :TagbarToggle<CR>
let TagbarOpenAutoClose = 0
let tagbar_autoclose = 0
let tagbar_autoopen = 1
let tagbar_left = 1
let tagbar_width=32

"golang
let g:tagbar_type_go = {
	\ 'ctagstype' : 'go',
	\ 'kinds'     : [
		\ 'p:package',
		\ 'i:imports:1',
		\ 'c:constants',
		\ 'v:variables',
		\ 't:types',
		\ 'n:interfaces',
		\ 'w:fields',
		\ 'e:embedded',
		\ 'm:methods',
		\ 'r:constructor',
		\ 'f:functions'
	\ ],
	\ 'sro' : '.',
	\ 'kind2scope' : {
		\ 't' : 'ctype',
		\ 'n' : 'ntype'
	\ },
	\ 'scope2kind' : {
		\ 'ctype' : 't',
		\ 'ntype' : 'n'
	\ },
	\ 'ctagsbin'  : 'gotags',
	\ 'ctagsargs' : '-sort -silent'
\ }

"ale
let g:ale_completion_enabled = 1
let g:ale_linters_explicit = 0
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

"python 
map <F5> :call RunPython()<CR>
func! RunPython()
    exec "W"
    if &filetype == 'python'
        exec "!time python %"
    endif
endfunc
" auto check syntax of python
autocmd BufWritePost *.py call flake8#Flake8()
let g:AutoPairsFlyMode = 1
let python_highlight_all=1
syntax on


"gcc
let g:ale_c_gcc_options = '-Wall -O2 -std=c99'
let g:ale_cpp_gcc_options = '-Wall -O2 -std=c++11'
let g:ale_c_cppcheck_options = ''
let g:ale_cpp_cppcheck_options = ''

"clang
let g:ale_cpp_clang_executable = 'clang++'
let g:ale_cpp_clang_options = '-std=c++11 -Wall'
let g:ale_cpp_cppcheck_executable = 'cppcheck'
let g:ale_cpp_cppcheck_options = ''

"nvcc
let g:ale_cuda_nvcc_options = '-std=c++11 -ccbin g++   -m64    -O3 -std=c++11  -lcublas -gencode arch=compute_70,code=sm_70 -gencode arch=compute_70,code=compute_70'

let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_enter = 0

nmap <silent> <C-j> <Plug>(ale_previous_wrap)
nmap <silent> <C-k> <Plug>(ale_next_wrap)
let g:ale_linters = {
\   'c++': ['cppcheck', 'clang'],
\   'cpp': ['cppcheck', 'clang'],
\   'cc': ['cppcheck', 'clang'],
\   'c': ['clang'],
\   'cuda': ['nvcc'],
\   'python': ['pylint'],
\}
