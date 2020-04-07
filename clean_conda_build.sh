echo "Extract archive"
mkdir new_tar
tar -xf test_release_4-0.1.016-py37_0.tar.bz2 -C ./new_tar || exit 1

echo "Create new archive"
cd new_tar || exit 1
tar -cjvf test_release_4-0.1.016-py37_0.tar.bz2 --exclude=info/recipe/dir_to_exclude --exclude=info/recipe/test --exclude=*.sh info Lib || exit 1
read _


conda convert --platform osx-64 test_release_4-0.1.016-py37_0.tar.bz2
read _
