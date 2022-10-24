#!/bin/bash

git clone https://git.faronear.org/fon/dot.vscode .vscode

mkdir cup
pushd cup
git clone https://git.faronear.org/cup/cmc-user-uniapp cmc-user-uniapp.git
git clone https://git.faronear.org/cup/cmc-server-torm cmc-server-torm.git
popd

mkdir fon
pushd fon
git clone https://git.faronear.org/npm/sysconfig sysconfig.git
git clone https://git.faronear.org/fon/www.faronear.com www.faronear.com.git
git clone https://git.faronear.org/fon/yapi.faronear.org yapi.faronear.org.git
git clone https://git.faronear.org/fon/git.faronear.org git.faronear.org.git
git clone https://git.faronear.org/fon/www.faronear.org www.faronear.org.git
git clone https://git.faronear.org/fon/mail.faronear.org mail.faronear.org.git
popd

mkdir npm
pushd npm
git clone https://git.faronear.org/npm/wo-base-fileloader wo-base-fileloader.git
git clone https://git.faronear.org/npm/wo-base-deployer wo-base-deployer.git
git clone https://git.faronear.org/npm/wo-base-envar wo-base-envar.git
git clone https://git.faronear.org/npm/wo-base-cocon wo-base-cocon.git
git clone https://git.faronear.org/npm/wo-base-messenger wo-base-messenger.git
git clone https://git.faronear.org/npm/wo-base-netinfo wo-base-netinfo.git
git clone https://git.faronear.org/npm/wo-base-webserver wo-base-webserver.git
git clone https://git.faronear.org/npm/wo-base-websocket-server wo-base-websocket-server.git
git clone https://git.faronear.org/npm/wo-base-webtoken wo-base-webtoken.git

git clone https://git.faronear.org/npm/wo-core-i18n wo-core-i18n.git
git clone https://git.faronear.org/npm/wo-core-toolkit wo-core-toolkit.git
git clone https://git.faronear.org/npm/wo-core-rpcsocket wo-core-rpcsocket.git

git clone https://git.faronear.org/npm/wo-user-part-uniapp wo-user-part-uniapp.git
git clone https://git.faronear.org/npm/wo-user-style-scss wo-user-style-scss.git
git clone https://git.faronear.org/npm/wo-user-toolkit-uniapp wo-user-toolkit-uniapp.git
git clone https://git.faronear.org/npm/wo-user-websocket-uniapp wo-user-websocket-uniapp.git

git clone https://git.faronear.org/npm/tic-crypto tic-crypto.git
git clone https://git.faronear.org/npm/tic-chaintool tic-chaintool.git
git clone https://git.faronear.org/npm/tic-traction tic-traction.git

git clone https://git.faronear.org/npm/vue-cli-uniapp vue-cli-uniapp.git
popd

mkdir sol
pushd sol
git clone https://git.faronear.org/sol/sol-ling sol-ling.git
git clone https://git.faronear.org/sol/sol-data sol-data.git
git clone https://git.faronear.org/sol/sol-base sol-base.git
git clone https://git.faronear.org/sol/solet solet.git
git clone https://git.faronear.org/sol/soweb soweb.git
popd

mkdir tic
pushd tic
git clone https://git.faronear.org/tic/cloud-server cloud-server.git
git clone https://git.faronear.org/tic/cloud-user-vue cloud-user-vue.git
git clone https://git.faronear.org/tic/star-core-torm star-core-torm.git
git clone https://git.faronear.org/tic/star-lens-uniapp star-lens-uniapp.git
git clone https://git.faronear.org/tic/star-lens-vue star-lens-vue.git
git clone https://git.faronear.org/tic/tic-blog-hexo tic-blog-hexo.git
git clone https://git.faronear.org/tic/tic-www-vue tic-www-vue.git

git clone https://git.faronear.org/tex/tex-basebank-java tex-basebank-java.git
git clone https://git.faronear.org/tex/tex-baserver-java tex-baserver-java.git
git clone https://git.faronear.org/tex/tex-team-vue tex-team-vue.git
git clone https://git.faronear.org/tex/tex-user-android tex-user-android.git
git clone https://git.faronear.org/tex/tex-user-ios tex-user-ios.git
git clone https://git.faronear.org/tex/tex-user-vue tex-user-vue.git

popd

mkdir tuc
pushd tuc

git clone https://git.faronear.org/tuc/fork-tisch fork/tisch.git
git clone https://git.faronear.org/tuc/fork-nesh fork/nesh.git
git clone https://git.faronear.org/tuc/fork-nbtc fork/nbtc.git

git clone https://git.faronear.org/tuc-pex/pex-blog-hexo pex/pex-blog-hexo.git
git clone https://git.faronear.org/tuc-pex/pex-chain-geth pex/pex-chain-geth.git
git clone https://git.faronear.org/tuc-pex/pex-contract-hardhat pex/pex-contract-hardhat.git
git clone https://git.faronear.org/tuc-pex/pex-server-torm pex/pex-server-torm.git
git clone https://git.faronear.org/tuc-pex/pex-user-uniapp pex/pex-user-uniapp.git

git clone https://git.faronear.org/tuc-log/log-team-uniapp log/log-team-uniapp.git
git clone https://git.faronear.org/tuc-log/log-server-mongo log/log-server-mongo.git
git clone https://git.faronear.org/tuc-log/log-server-torm log/log-server-torm.git
git clone https://git.faronear.org/tuc-log/log-user-react log/log-user-react.git
git clone https://git.faronear.org/tuc-log/log-user-uniapp log/log-user-uniapp.git
git clone https://git.faronear.org/tuc-log/log-user-vue log/log-user-vue.git
git clone https://git.faronear.org/tuc-log/log-blog-hexo log/log-blog-hexo.git

git clone https://git.faronear.org/tuc-vic/vic.server.mongo vic/vic.server.mongo.git
git clone https://git.faronear.org/tuc-vic/vic.user.react vic/vic.user.react.git
git clone https://git.faronear.org/tuc-vic/vic.webhome.hexo vic/vic.webhome.hexo.git
git clone https://git.faronear.org/tuc-vic/vic.market vic/vic.market.git
git clone https://git.faronear.org/tuc-vic/vic.admin.vue vic/vic.admin.vue.git

git clone https://git.faronear.org/tuc-fiv/fiv.webhome.hexo fiv.webhome.hexo.git
git clone https://git.faronear.org/tuc-fiv/fiv.server.mongo fiv.server.mongo.git
git clone https://git.faronear.org/tuc-fiv/fiv.user.react fiv.user.react.git

popd
