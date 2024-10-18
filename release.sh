# replace version
cd alist-web
version=$(git describe --abbrev=0 --tags)
sed -i -e "s/\"version\": \"0.0.0\"/\"version\": \"$version\"/g" package.json
cat package.json

# build
wget https://crowdin.com/backend/download/project/alist/zh-CN.zip 
unzip zh-CN.zip
wget https://crowdin.com/backend/download/project/alist/zh-TW.zip 	
unzip zh-TW.zip
wget https://crowdin.com/backend/download/project/alist/ja.zip 
unzip ja.zip
pnpm install
node ./scripts/i18n.mjs
rm zh-CN.zip
rm zh-TW.zip
rm ja.zip
pnpm build
cp -r dist ../
cd ..

# commit to web-dist
cd web-dist
rm -rf dist
cp -r ../dist .
git add .
git config --local user.email "i@nn.ci"
git config --local user.name "Noah Hsu"
git commit --allow-empty -m "upload $version dist files" -a
git tag -a $version -m "release $version"
cd ..

mkdir compress
tar -czvf compress/dist.tar.gz dist/*
zip -r compress/dist.zip dist/*
