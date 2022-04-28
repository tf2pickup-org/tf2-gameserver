FROM melkortf/tf2-competitive:1.6.3
LABEL maintainer="garrappachc@gmail.com"

COPY checksum.md5 .

# System2 is dependency of the connector plugin
ARG SYSTEM2_URL=https://forums.alliedmods.net/attachment.php?attachmentid=188744&d=1618607414
ARG SYSTEM2_FILE_NAME=system2.zip

# SteamWorks is also a dependency of the connector plugin
ARG STEAMWORKS_URL=https://github.com/KyleSanderson/SteamWorks/releases/download/1.2.3c/package-lin.tgz
ARG STEAMWORKS_FILE_NAME=steamworks.tgz

ARG CONNECTOR_PLUGIN_FILE_NAME=connector.smx
ARG CONNECTOR_PLUGIN_VERSION=0.4.0
ARG CONNECTOR_PLUGIN_URL=https://github.com/tf2pickup-org/connector/releases/download/${CONNECTOR_PLUGIN_VERSION}/${CONNECTOR_PLUGIN_FILE_NAME}

ARG TEAMS_PLUGIN_FILE_NAME=teams.smx
ARG TEAMS_PLUGIN_URL=https://github.com/tf2pickup-org/stadium-sm-plugin/raw/master/${TEAMS_PLUGIN_FILE_NAME}

RUN \
  # download all the plugins
  wget -nv "${CONNECTOR_PLUGIN_URL}" "${TEAMS_PLUGIN_URL}" \
  && wget -nv "${SYSTEM2_URL}" -O "${SYSTEM2_FILE_NAME}" \
  && wget -nv "${STEAMWORKS_URL}" -O "${STEAMWORKS_FILE_NAME}" \
  # verify checksums
  && md5sum -c checksum.md5 \
  # install plugins
  && unzip -q "${SYSTEM2_FILE_NAME}" -d "${SERVER_DIR}/tf/addons/sourcemod/" \
  && tar -xf "${STEAMWORKS_FILE_NAME}" --strip-components=1 -C "${SERVER_DIR}/tf/" \
  && mv "${CONNECTOR_PLUGIN_FILE_NAME}" "$SERVER_DIR/tf/addons/sourcemod/plugins/${CONNECTOR_PLUGIN_FILE_NAME}" \
  && mv "${TEAMS_PLUGIN_FILE_NAME}" "$SERVER_DIR/tf/addons/sourcemod/plugins/${TEAMS_PLUGIN_FILE_NAME}" \
  # cleanup
  && rm "${SYSTEM2_FILE_NAME}" "${STEAMWORKS_FILE_NAME}" \
  && rm "checksum.md5" \
  # DM is conflicting with the ready up mode
  && rm "${SERVER_DIR}/tf/addons/sourcemod/plugins/soap_tf2dm.smx" \
    "${SERVER_DIR}/tf/addons/sourcemod/plugins/soap_tournament.smx"

ENV TEAM_SIZE=6
ENV TF2PICKUPORG_API_ADDRESS=
ENV TF2PICKUPORG_SECRET=
ENV TF2PICKUPORG_VOICE_CHANNEL_NAME=
ENV TF2PICKUPORG_PRIORITY=1
ENV TF2PICKUPORG_OVERRIDE_INTERNAL_ADDRESS=

COPY server.cfg.template ${SERVER_DIR}/tf/cfg/server.cfg.template
