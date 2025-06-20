#!/bin/bash

./srcds_run \
  -console \
  -debug \
  -game csco/csgo \
  -tickrate 128 \
  -usercon \
  -insecure \
  -port 27015 \
  +net_public_adr <YOUR_PUBLIC_IP> \
  +map de_dust2 \
  +maxplayers 20 \
  +sv_setsteamaccount <YOUR_TOKEN> \
  +sv_region 7 \
  +sv_tags "RTV,NOMINATE"

