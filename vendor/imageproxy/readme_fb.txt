FB customized imageproxy

branch managment:
1. master : should be align with upstream master
2. fb_master : feebee's master (our binary will built on this branch)
3. fb_<feature_branch> : new feature added by feebee

upgrade version:
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


how to update depedencies:(govendor) : build image proxy 不depends on willnorris.com/go的版本
 - 因為git clone 出來的imageproxy default是會直接depends willnorris.com/go的版本, 所以直接改git的source沒有用, 因為他直接depends on willnorris.com/go
 - 以下步驟會decouple 直接depends on willnorris.com/go的版本,改depend on git的版本
 - 如果沒有decouple willnorris.com/go的depedencies 在go build時會出現以下error:
   - src/imageproxy/cmd/imageproxy/main.go:37:2: cannot find package "willnorris.com/go/imageproxy" in any of:...


1. run step 1 ~ step 3 from (first time build a imageproxy binary from fb_master)
2. remove willnorris.com/go namespace (git show a3e2e0538ff0c0d611e79c417a2cce36d157f3cc)
3. run govendor (ref: document https://vonalex.github.io/2017/05/02/go%E4%BE%9D%E8%B5%96%E7%AE%A1%E7%90%86-govendor/)
   download govendor (go get -u github.com/kardianos/govendor) need  create another go-workspace

4. run govendor update
   cd $GOPATH/src/imageproxy
   ~/govendor/bin/govendor update imageproxy

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

