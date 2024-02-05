function install_vim()
{

  # CentOS
  sudo yum install ncurses-devel
  #wget https://github.com/vim/vim/archive/master.zip
  #unzip master.zip
  #pushd vim-master/src/
  #./configure --enable-python3interp  && make -j64 && sudo make install
  #popd
  #rm vim-master master.zip -rf
  chmod a+x vim
  sudo mkdir -p /usr/local/share/vim
  sudo cp -rf vim90 /usr/local/share/vim/
  mkdir -p ~/bin && cp vim ~/bin/
  echo "export PATH=~/bin:$PATH" >> ~/.bashrc
}

function set_vim()
{
  cd ctags && ./autogen.sh && ./configure && make -j32 && sudo make install && cd ..
  cp vimrc ~/.vimrc -rf
  cp vimsrc ~/.vim  -rf

  cat bashrc >> ~/.bashrc
}



install_vim
set_vim
