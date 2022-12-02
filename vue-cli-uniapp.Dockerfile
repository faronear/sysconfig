FROM node:16
LABEL luk "luk@faronear.org"

RUN npm i -g --registry https://registry.npm.taobao.org @vue/cli@4
RUN RUN cd / && echo -e "\n" | vue create --registry https://registry.npm.taobao.org -p dcloudio/uni-preset-vue vue-cli-uniapp
RUN cd /vue-cli-uniapp && npm i -D --registry https://registry.npm.taobao.org sass@1.49.8 sass-loader@8.0.2

EXPOSE 8080

CMD cd /vue-cli-uniapp && npm run serve

# docker build -t luk/name:tag .
# docker run -d -p 8082:8080 -v /home/adot/pex-user-uniapp:/vue-cli-uniapp/src luk/vue-cli-uniapp