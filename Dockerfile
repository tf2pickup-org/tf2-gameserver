ARG REGISTRY=ghcr.io
ARG TF2_COMPETITIVE_VERSION=3.2.2
FROM ${REGISTRY}/melkortf/tf2-competitive:${TF2_COMPETITIVE_VERSION}
LABEL maintainer="garrappachc@gmail.com"

COPY checksum.md5 .

# System2 is dependency of the connector plugin
ARG SYSTEM2_URL=https://forums.alliedmods.net/attachment.php?attachmentid=188744&d=1618607414
ARG SYSTEM2_FILE_NAME=system2.zip

ARG CONNECTOR_PLUGIN_FILE_NAME=connector.smx
ARG CONNECTOR_PLUGIN_VERSION=0.6.0
ARG CONNECTOR_PLUGIN_URL=https://github.com/tf2pickup-org/connector/releases/download/${CONNECTOR_PLUGIN_VERSION}/${CONNECTOR_PLUGIN_FILE_NAME}

ARG TEAMS_PLUGIN_FILE_NAME=teams.smx
ARG TEAMS_PLUGIN_URL=https://github.com/tf2pickup-org/stadium-sm-plugin/raw/master/${TEAMS_PLUGIN_FILE_NAME}

ARG STAC_PLUGIN_VERSION=v6.0.5
ARG STAC_PLUGIN_FILE_NAME=stac.zip
ARG STAC_PLUGIN_URL=https://github.com/sapphonie/StAC-tf2/releases/download/${STAC_PLUGIN_VERSION}/${STAC_PLUGIN_FILE_NAME}

RUN \
  # download all the plugins
  wget -nv "${CONNECTOR_PLUGIN_URL}" "${TEAMS_PLUGIN_URL}" "${STAC_PLUGIN_URL}" \
  && wget -nv "${SYSTEM2_URL}" -O "${SYSTEM2_FILE_NAME}" \
  # verify checksums
  && md5sum -c checksum.md5 \
  # install plugins
  && unzip -q "${SYSTEM2_FILE_NAME}" -d "${SERVER_DIR}/tf/addons/sourcemod/" \
  && mv "${CONNECTOR_PLUGIN_FILE_NAME}" "$SERVER_DIR/tf/addons/sourcemod/plugins/${CONNECTOR_PLUGIN_FILE_NAME}" \
  && mv "${TEAMS_PLUGIN_FILE_NAME}" "$SERVER_DIR/tf/addons/sourcemod/plugins/${TEAMS_PLUGIN_FILE_NAME}" \
  && unzip -q -o "${STAC_PLUGIN_FILE_NAME}" -d "${SERVER_DIR}/tf/addons/sourcemod/" \
  # cleanup
  && rm "${SYSTEM2_FILE_NAME}" \
  && rm "${STAC_PLUGIN_FILE_NAME}" \
  && rm "checksum.md5" \
  # DM is conflicting with the ready up mode
  && rm "${SERVER_DIR}/tf/addons/sourcemod/plugins/soap_tf2dm.smx" \
  "${SERVER_DIR}/tf/addons/sourcemod/plugins/soap_tournament.smx"

ENV TEAM_SIZE=6
ENV TF2PICKUPORG_API_ADDRESS=
ENV TF2PICKUPORG_SECRET=
ENV TF2PICKUPORG_PRIORITY=1
ENV TF2PICKUPORG_OVERRIDE_INTERNAL_ADDRESS=
ENV TF2PICKUPORG_OVERRIDE_PUBLIC_ADDRESS=

COPY server.cfg.template ${SERVER_DIR}/tf/cfg/server.cfg.template
COPY stac.cfg  ${SERVER_DIR}/tf/cfg/sourcemod/stac.cfg
