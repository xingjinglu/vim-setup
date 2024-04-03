function gentags(){
  rm cscope.out tags.lst tags | true
  ctags -R --langmap=C++:+.cl.cu.cuh.proto.cc.cpp.metal.hpp,C:.c,Python:+.py,Asm:+.S.s,Sh:.sh,Perl:+.pl * 

  touch tags.lst
  find . | grep "\.c$" >> tags.lst
  find . | grep "\.cu$" >> tags.lst
  find . | grep "\.cuh$" >> tags.lst
  find . | grep "\.cpp$" >> tags.lst
  find . | grep "\.cc$" >> tags.lst
  find . | grep "\.mm$" >> tags.lst
  find . | grep "\.metal$" >> tags.lst
  find . | grep "\.h$" >> tags.lst
  find . | grep "\.hpp$" >> tags.lst
  find . | grep "\.py$" >> tags.lst
  find . | grep "\.pl$" >> tags.lst
  find . | grep "\.cl$" >> tags.lst
  find . | grep "\.proto$" >> tags.lst
  cscope -k -q -b  -i tags.lst
}


