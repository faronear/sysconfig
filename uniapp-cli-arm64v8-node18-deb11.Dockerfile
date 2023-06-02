FROM arm64v8/node:18.16-bullseye
LABEL org.opencontainers.image.authors="luk"

RUN npm i -g --registry https://registry.npm.taobao.org @vue/cli@4
RUN cd / && echo -e "\n" | vue create --registry https://registry.npm.taobao.org -p dcloudio/uni-preset-vue uniapp-cli
# 上一行自动选择了第一个空模板，因此需要额外安装 sass
RUN cd /uniapp-cli && npm i -D --registry https://registry.npm.taobao.org sass@1.49.8 sass-loader@8.0.2

EXPOSE 8080

CMD cd /uniapp-cli && npm run serve

# docker build -t uniapp-cli .
# docker tag uniapp-cli anolaxy/uniapp-cli:node18.16-debian11.5-arm64v8 // alpine3.16
# docker login
# docker push anolaxy/uniapp-cli:node18.16-debian11.5-arm64v8 // alpine3.16
# docker run -d -p 8080:8080 -v /home/adot/pex-user-uniapp:/uniapp-cli/src anolaxy/uniapp-cli:node18.16-debian11.5-arm64v8 // alpine3.16
