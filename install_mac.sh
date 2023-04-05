set -xe

echo "bash install.sh"
echo "not with sudo"
# Set up http proxy if needed.
#export https_proxy=http://xx.xx.xx.xx:8080
#export http_proxy=http://xx.xx.xx.xx:8080


function install_vim()
{
  # 1. Upgrade vim to 8.1.
  git clone https://github.com/vim/vim.git |true
  cd vim 
  ./configure --with-features=huge --enable-gui=gtk2 --enable-cscope
  make -j32
  make install
  cd ..
  rm -rf vim
}


function install_with_sudo()
{
  # Ubuntu
  apt-get install libncurses-dev -y

  apt install -y ctags
  apt install cscope -y
  apt install -y make
  apt install -y cmake
  apt install -y curl  

}


function install_basic()
{
#add-apt-repository ppa:jonathonf/vim -y |true
#apt update -y |true

# pre-request
#brew install ctags
#brew install make
#brew install cmake
#brew install cscope

# 1. install tools with sudo
#install_with_sudo

# 2. clang
#apt install clang -y |true

## 2.1 Install pathogen  

# Install vim
#install_vim

# ~/.vim/bundle是pathogen默认runtimepath，把所有的plugin放到该目录即可
curl -LSso autoload/pathogen.vim https://tpo.pe/pathogen.vim | true
mkdir bundle |true
cp -rf ale gundo.vim neocomplete.vim powerline vim-gocode vim-markdown vim-sensible nerdtree tagbar vim-go ./bundle/ |true

if [ ! -d ~/.vim ];then 
  mkdir -p ~/.vim
fi

cp -rf ./autoload  ~/.vim/ |true
cp -rf ./bundle  ~/.vim/  |true
cp -rf ./pack ~/.vim/  |true
cp -rf ./plugin ~/.vim/  |true
cp -rf ./syntax ~/.vim/  |true
#cp -rf ./view ~/.vim/    |true
cp -rf ./pyformat.py ~/.vim/  |true
cp -rf ./doc ~/.vim/   |true

# 3. Setup .vimrc
cat >  ~/.vimrc <<EOF
execute pathogen#infect()
syntax on
filetype plugin indent on

" cscope related
set nocscopeverbose  

if has('mouse')
  set mouse=a
endif
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

let Tlist_Auto_Open = 0
let Tlist_Auto_Update = 0

set cscopetag
set textwidth=80
set colorcolumn=80


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

function! GenTags()
  let curdir=getcwd()
  while !filereadable("./tags")
    cd ..
    if getcwd() == "/"
      break
    endif
  endwhile

  !rm cscope.out tags.lst tags |true
  !touch tags.lst
  !find | grep "\.c$" >> tags.lst
  !find | grep "\.cc$" >> tags.lst
  !find | grep "\.cpp$" >> tags.lst
  !find | grep "\.hpp$" >> tags.lst
  !find | grep "\.h$" >> tags.lst
  !find | grep "\.cu$" >> tags.lst
  !find | grep "\.cuh$" >> tags.lst
  !find | grep "\.py$" >> tags.lst
  !find | grep "\.pl$" >> tags.lst
  !find | grep "\.cl$" >> tags.lst
  !cscope -i -b tags.lst

  !ctags -R --langmap=C++:+.cl,C:.c,Python:.py:Asm:+.S.s,Sh:.sh,Perl:+.pl *
  execute ":cd " . curdir
endfunction
nmap <F10> :call GenTags()<CR>    

autocmd FileType c,cpp,cc,h setlocal textwidth=80 formatoptions+=t
au FileType python set expandtab shiftwidth=4 tabstop=4

" OpenCL format.
autocmd BufNewFile,BufRead *.cl set filetype=opencl
autocmd FileType opencl source /search/speech/luxingjing/.vim/plugin/opencl.vim
autocmd BufNewFile,BufRead *.cc set filetype=cpp
autocmd BufNewFile,BufRead *.cpp set filetype=cpp

"NerdTree
nnoremap <silent> <F3> :NERDTree <CR>
let NERDTreeWinPos="right"

"TagbarToggle
nnoremap <silent> <F2> :TagbarToggle<CR>
let TagbarOpenAutoClose = 0
let tagbar_autoclose = 0
let tagbar_autoopen = 1
let tagbar_left = 1
let tagbar_width=32

"ale
let g:ale_completion_enabled = 1
let g:ale_linters_explicit = 0
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

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
EOF
}

function  install_go()
{

# 4. Install go
#sudo yum -y install go
wget https://dl.google.com/go/go1.11.2.linux-amd64.tar.gz
tar xzf  go1.11.2.linux-amd64.tar.gz
sudo cp -rf go /usr/local/

mkdir -p  ~/software/go_workspace
cat >> ~/.bashrc <<EOF
export GOPATH=~/software/go_workspace
export GOROOT=/usr/local/go
export PATH=\$PATH:\$GOPATH/bin:\$GOROOT/bin
EOF
source ~/.bashrc


# 4.1 配置vim-go,会自动从网上下载相应包
curl -fLo autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim | true

go get -u github.com/jstemmer/gotags
go get -u github.com/mdempsky/gocode



# pushd ~/.vim/bundle
# vim t
# :Helptags

# :GoInstallBinaries


cat >>  ~/.vimrc <<EOF
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
EOF



# Install other stuffs.

# Generate help docs
#vim t
#:Helptags  # 自动生成所有plugin的文档

pushd ~/.vim/bundle
echo "vim t"
echo ":GoInstallBinaries"
comm
}

if [ $# == 0 ];then
  echo $#
  install_basic
elif [ $1 == 0 ];then
  install_basic
elif [ $1 == 1 ];then
  install_go
fi
