fully build
-----------
1. create a workspace_directory, ie /home/bclow/go_workspace
mkdir -p /home/bclow/go_workspace/src

2. checkout imageproxy
cd /home/bclow/go_workspace/src
git clone  git@github.com:thefirstweb/imageproxy.git 

3. checkout fb_branch
git checkout 1_1__return-500-if-img-error

4. build 
/home/bclow/go_workspace/src/imageproxy/build/build.sh 

5. binary will generate on /home/bclow/go_workspace/bin/imageproxy


modify
------
1. code modify for imageproxy vs cmd/imageproxy/main.go
1.1 imageproxy
1.1.1 change code
1.1.2 build/vendor_update.sh 0  ---> compiling will only depend on vendor/imageproxy/imageproxy.go (instead of imageproxy.go)
1.1.3 build/build.sh 0
1.1.4 repeat 1.1.1 -> 1.1.3 
1.1.5 commit everything 
1.1.6 checkout to another directory and run build.sh without 0

test case:
----------
1.bad https certificate 
curl -v   'http://n16:8080/200/https://expired.badssl.com/icons/favicon-red.ico'

2. badimg.jpg is html document, reponse HTTP 500
curl -v   'http://n16:8080/200/http://s0.feebee.com.tw/badimg.jpg'

3. badimg2.jpg is not valid utf-8 , reponse original 
curl -v   'http://n16:8080/200/http://s0.feebee.com.tw/badimg2.jpg'

