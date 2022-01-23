FROM melkortf/tf2-competitive:1.5.1
LABEL maintainer="garrappachc@gmail.com"

# DM is conflicting with the ready up mode
RUN rm "${SERVER_DIR}/tf/addons/sourcemod/plugins/soap_tf2dm.smx" \
  && rm "${SERVER_DIR}/tf/addons/sourcemod/plugins/soap_tournament.smx" \
  # system2 is dependency of connector
  && wget -nv "https://forums.alliedmods.net/attachment.php?attachmentid=188744&d=1618607414" -O system2.zip \
  && unzip -o system2.zip -d "${SERVER_DIR}/tf/addons/sourcemod/" \
  && rm -f system2.zip \
  # SteamWorks is also a dependency of the connector plugin
  && wget -nv "https://github.com/KyleSanderson/SteamWorks/releases/download/1.2.3c/package-lin.tgz" -O steamworks.tgz \
  && tar -xf steamworks.tgz --strip-components=1 -C "${SERVER_DIR}/tf/" \
  && rm -f steamworks.tgz \
  && wget -nv "https://github.com/tf2pickup-org/connector/releases/download/0.4.0/connector.smx" -O "$SERVER_DIR/tf/addons/sourcemod/plugins/connector.smx" \
  && wget -nv "https://github.com/tf2pickup-org/stadium-sm-plugin/raw/master/teams.smx" -O "$SERVER_DIR/tf/addons/sourcemod/plugins/teams.smx"

ENV TEAM_SIZE=6
ENV TF2PICKUPORG_API_ADDRESS=
ENV TF2PICKUPORG_SECRET=
ENV TF2PICKUPORG_VOICE_CHANNEL_NAME=
ENV TF2PICKUPORG_PRIORITY=1
ENV TF2PICKUPORG_OVERRIDE_INTERNAL_ADDRESS=

COPY server.cfg.template ${SERVER_DIR}/tf/cfg/server.cfg.template
