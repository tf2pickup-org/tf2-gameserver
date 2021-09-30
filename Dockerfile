FROM melkortf/tf2-competitive:1.1.4
LABEL maintainer="garrappachc@gmail.com"

# DM is conflicting with the ready up mode
RUN rm $SERVER_DIR/tf/addons/sourcemod/plugins/soap_{tf2dm,tournament}.smx

RUN wget "https://forums.alliedmods.net/attachment.php?attachmentid=188744&d=1618607414" -O system2.zip \
  && unzip -o system2.zip -d "${SERVER_DIR}/tf/addons/sourcemod/" \
  && rm -f system2.zip \
  && wget "https://github.com/KyleSanderson/SteamWorks/releases/download/1.2.3c/package-lin.tgz" -O steamworks.tgz \
  && tar -xf steamworks.tgz --strip-components=1 -C "${SERVER_DIR}/tf/" \
  && rm -f steamworks.tgz \
  && wget "https://github.com/tf2pickup-org/connector/releases/download/0.0.1/connector.smx" -O $SERVER_DIR/tf/addons/sourcemod/plugins/connector.smx \
  && wget "https://github.com/tf2pickup-org/stadium-sm-plugin/raw/master/teams.smx" -O $SERVER_DIR/tf/addons/sourcemod/plugins/teams.smx

ENV TEAM_SIZE=6
ENV TF2PICKUPORG_API_ADDRESS=
ENV TF2PICKUPORG_SECRET=

COPY server.cfg.template ${SERVER_DIR}/tf/cfg/server.cfg.template
