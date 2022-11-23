if test "$1" = "./install.sh"
then
  rm -rf test
  mkdir test
fi

for i in $(ls)
do
  if test "$i" != "test"
  then
    cp -r $i test/
  fi
done

d=$(pwd)
cd test
"$@"
cd $d
