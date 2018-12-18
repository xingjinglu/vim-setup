
## 1. 利用 pathogen tool 配置vim.

- Install  
Make sure there are internets.
```bash
git clone https://github.com/xingjinglu/vim-setup.git

cd vim-setup

# It will re-install go into /usr/local. Please comment them if you don't need.
bash install.sh 

```
- Generate docs and config vim-go
```
vim t
:Helptags
:GoInstallBinaries
```

## 2. VIM setup tips   
### 2.1 解决tagbar对OpenCL或者其他扩展语言的支持问题    
- Let ctags support OpenCL  
```bash 
ctags -R --langmap=C++:+.cl,C:.c,Python:.py:Asm:+.S.s,Sh:.sh *
```

- Let cscope parse more files    
```
touch tags.lst
find | grep "\.c$" >> tags.lst
find | grep "\.cpp$" >> tags.lst	
find | grep "\.h$" >> tags.lst
cscope -i tags.lst
```

- Let tagbar support OpenCL filetype  
```
vim ~/.vim/bundle/tagbar/autoload/tagbar/types/ctags.vim  

# Insert the below line
   let types.cpp = type_cpp                                                    
   let types.opencl = type_cpp
   
# In ~/.vimrc, Add below lines
filetype on                                                                     
filetype plugin on

" OpenCL format.                                                                
autocmd BufNewFile,BufRead *.cl set filetype=opencl                             
autocmd FileType opencl source /search/speech/luxingjing/.vim/plugin/opencl.vim


# Comment
When the version of tagbar are differnent, the file of insert "type.opencl..." maybe different or under differnent directory,
please seach the keywords "types.cpp = type_cpp" to get the right position. 
```

- Define a function to get ctags and cscope files  
```
function gentags(){
  rm cscope.out tags.lst tags 
  touch tags.lst                                                                
  find | grep "\.c$" >> tags.lst                                                
  find | grep "\.cpp$" >> tags.lst                                              
  find | grep "\.h$" >> tags.lst                                                
  find | grep "\.py$" >> tags.lst                                               
  find | grep "\.pl$" >> tags.lst                                               
  find | grep "\.cl$" >> tags.lst                                               
  cscope -i tags.lst                                                            
                                                                                
  ctags -R --langmap=C++:+.cl,C:.c,Python:.py:Asm:+.S.s,Sh:.sh,Perl:+.pl *      
}                              
```








