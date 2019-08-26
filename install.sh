set -xe

# Set up http proxy if needed.
#export https_proxy=http://xx.xx.xx.xx:8080
#export http_proxy=http://xx.xx.xx.xx:8080



function install_basic()
{
# 1. Upgrade vim to 8.1.
sudo yum install ncurses-devel
wget https://github.com/vim/vim/archive/master.zip
unzip master.zip
pushd vim-master/src/
./configure && make -j64 && sudo make install
popd
rm vim-master master.zip -rf

sudo mv /usr/bin/vim /usr/bin/vim.bak
sudo ln /usr/local/bin/vim /usr/bin -s


# 2. Install pathogen  
# ~/.vim/bundle是pathogen默认runtimepath，把所有的plugin放到该目录即可
curl -LSso autoload/pathogen.vim https://tpo.pe/pathogen.vim | true

# 3. Setup .vimrc
cat >  ~/.vimrc <<EOF
execute pathogen#infect()
syntax on
filetype plugin indent on

" cscope related
set nocscopeverbose  

set mouse=ar
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

au FileType python set expandtab shiftwidth=4 tabstop=4

" OpenCL format.
autocmd BufNewFile,BufRead *.cl set filetype=opencl
autocmd FileType opencl source /search/speech/luxingjing/.vim/plugin/opencl.vim

"NerdTree
nnoremap <silent> <F2> :NERDTree <CR>

"TagbarToggle
nnoremap <silent> <F7> :TagbarToggle<CR>
let TagbarOpenAutoClose = 0
let tagbar_autoclose = 0
let tagbar_autoopen = 1
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


cp -rf ./autoload  ~/.vim/
cp -rf ./bundle  ~/.vim/
cp -rf ./pack ~/.vim/
cp -rf ./plugin ~/.vim/
cp -rf ./syntax ~/.vim/
cp -rf ./view ~/.vim/
cp -rf ./pyformat.py ~/.vim/
cp -rf ./doc ~/.vim/

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

if [ $# == 0 ]
then
  echo $#
  install_basic
elif[ $0 == 0 ]
  install_basic
elif[ $0 == 1 ]
  install_go
fi
