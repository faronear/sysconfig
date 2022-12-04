FROM node:16.18-bullseye
LABEL org.opencontainers.image.authors="luk"

RUN npm i -g --registry https://registry.npm.taobao.org @vue/cli@4
RUN cd / && echo -e "\n" | vue create --registry https://registry.npm.taobao.org -p dcloudio/uni-preset-vue uniapp-cli
RUN cd /uniapp-cli && npm i -D --registry https://registry.npm.taobao.org sass@1.49.8 sass-loader@8.0.2

EXPOSE 8080

CMD cd /uniapp-cli && npm run serve

# docker commit [container-id] [new-image-name]
# docker build -t [image-name] .
# docker tag [image-name] anolaxy/uniapp-cli:node16.18-alpine3.16
# docker login
# docker push anolaxy/uniapp-cli:node16.18-alpine3.16
# docker run -d -p 8080:8080 -v /home/adot/pex-user-uniapp:/uniapp-cli/src anolaxy/uniapp-cli:node16.18-alpine3.16
