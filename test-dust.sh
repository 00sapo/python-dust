if test "$1" = "./install.sh"
then
  rm -rf test/*
  rm -rf test/.*
fi

for i in $(ls)
do
  if test "$i" != "test"
  then
    cp -r $i test/
  fi
done

cp .pyenv-source.* test/
d=$(pwd)
cd test
"$@"
cd $d
