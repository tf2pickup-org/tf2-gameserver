FROM melkortf/tf2-competitive:1.1.4
LABEL maintainer="garrappachc@gmail.com"

# DM is conflicting with the ready up mode
RUN rm $SERVER_DIR/tf/addons/sourcemod/plugins/soap_{tf2dm,tournament}.smx

RUN wget https://github.com/tf2pickup-pl/stadium-sm-plugin/raw/master/teams.smx -O $SERVER_DIR/tf/addons/sourcemod/plugins/teams.smx

ENV TEAM_SIZE=6
COPY server.cfg.template ${SERVER_DIR}/tf/cfg/server.cfg.template
