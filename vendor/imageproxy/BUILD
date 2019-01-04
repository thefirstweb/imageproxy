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

test case:
1.bad https certificate 
curl -v   'http://n16:8080/200/https://expired.badssl.com/icons/favicon-red.ico'

2. badimg.jpg is html document, reponse HTTP 500
curl -v   'http://n16:8080/200/http://s0.feebee.com.tw/badimg.jpg'

3. badimg2.jpg is not valid utf-8 , reponse original 
curl -v   'http://n16:8080/200/http://s0.feebee.com.tw/badimg2.jpg'

