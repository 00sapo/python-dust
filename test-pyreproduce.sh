rm -rf test/*
rm -rf test/.*
for i in $(ls)
do
  if test "$i" != "test"
  then
    cp -r $i test/
  fi
done

cp .pyenv-source.txt test/
./test/"$@"
