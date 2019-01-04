1. version history see version.txt
2. how to build see BUILD

FB customized imageproxy
ref: https://golang.org/doc/code.html
ref: https://blog.golang.org/organizing-go-code

基本概念:
0. 原本github直接checkout出的src 的架構是: 
   0.1 程式的main : imageproxy/cmd/imageproxy/main.go

   0.2 main.go 會require imageproxy : 但是是 
   -       "willnorris.com/go/imageproxy"
   -       "willnorris.com/go/imageproxy/internal/gcscache"
   -       "willnorris.com/go/imageproxy/internal/s3cache"

   0.3 go build 的時候, 會直接去github 拉depedency (github 上會有一個meta 檔案紀錄目前stable的版本是哪一個git revision, 所以不會拉到wip的版本) 
       go build 的時候好像是會用go get去拉depedency, 這點還不太確定. 

   0.4 其他的depedency也會一起拉回來(有的在golang, 有的在github) 
   0.5 go都是static link, runtime完就沒有depedency的問題
   0.6 如果從github直接拉下來, 祇能改imageproxy/cmg/imageproxy/main.go裡的東西才會有影響. imageproxy本身的code, 雖然在同一個github repository, 但是main reference的是remote的版本. 所以祇有修改imageproxy/cmg/imageproxy/main.go才會有效


1. imageproxy package是imageproxy core library
2. imageproxy/cmd/imageporxy 才是 imageproxy main
3. 如果祇改imageproxy main(ie,加參數, print debug informaion)直接build 就好($GO build imageproxy/cmd/imageproxy
4. 如果改imageproxy (imageproxy的dependent, 例如:取消ssl certifiate check), 需要:
   4.1 govendor update imageporxy, 
   4.2 $GO build imageproxy/cmd/imageproxy


branch managment:
1. master : should be align with upstream master
2. fb_master : feebee's master (our binary will built on this branch)
3. fb_<feature_branch> : new feature added by feebee

upgrade version to upstream:
1. merge upstream/master into origin/master

first time build a imageproxy binary from fb_master:
1. create a go workspace, ie:
   mkdir -p ~/git/imageproxy_workspace/src

2. export GOPATH
   export GOPATH=~/git/imageproxy_workspace

3. git clone
   cd $GOPATH/src
   git clone  git@github.com:thefirstweb/imageproxy.git
   cd imageproxy
   git remote add upstream git@github.com:willnorris/imageproxy.git
   git checkout fb_master

4. go build
   cd $GOPATH
   $GO build imageproxy/cmd/imageproxy   # GO must be 1.10.1 and above


update imageproxy

how to update depedencies:(govendor) : build image proxy 不depends on willnorris.com/go的版本
 - 因為git clone 出來的imageproxy default是會直接depends willnorris.com/go的版本, 所以直接改git的source沒有用, 因為他直接depends on willnorris.com/go
 - 以下步驟會decouple 直接depends on willnorris.com/go的版本,改depend on git的版本
 - 如果沒有decouple willnorris.com/go的depedencies 在go build時會出現以下error:
   - src/imageproxy/cmd/imageproxy/main.go:37:2: cannot find package "willnorris.com/go/imageproxy" in any of:...


1. run step 1 ~ step 3 from (first time build a imageproxy binary from fb_master)
2. remove willnorris.com/go namespace (git show a3e2e0538ff0c0d611e79c417a2cce36d157f3cc)
3. run govendor (ref: document https://vonalex.github.io/2017/05/02/go%E4%BE%9D%E8%B5%96%E7%AE%A1%E7%90%86-govendor/)
   download govendor (go get -u github.com/kardianos/govendor) need  create another go-workspace

4. run govendor update(我們自己run govendor的commit log :
   cd $GOPATH/src/imageproxy
   ~/govendor/bin/govendor update imageproxy

   (git show 588e3a2f2e9c669705b54ca0e2f649ddffb27d92
    git show b9fa94f8a37fb2226d1ca0171fda2066fbf6d3c0)

5. build binary
   $GO build imageproxy/cmd/imageproxy   # GO must be 1.10.1 and above




問題:
1. 要手動建go workspace, ie, src/<project>/<git content>, 有一點不直覺.
2. 還是需要改code(remove willnorris.com/go/ namespace的部份)
3. 還不太了解govendor的用法
4. 版本tracking:
   .有沒有辦法知道某個binary 是從那個一fb_master的commit sha1產生的?
    - 要想辦法把git revision number build進binary裡
.有沒有辦法知道目前的binary是從那個master build出來的?
.有沒有辦法知道如果merge upstream/master會改了什麼東西
 - 建立一個pull request就可以知道如果merge upstream/master 會改變什麼
.有沒有辦法知某個binary 裡有包括那些fb做過的patch ?

