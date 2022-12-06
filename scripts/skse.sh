#!/usr/bin/env bash
env \
  PROTON_ENABLE_NVAPI=1 \
  DXVK_CONFIG_FILE=~/.dxvk.conf \
  STEAM_COMPAT_CLIENT_INSTALL_PATH=/usr/games/steam  \
  STEAM_COMPAT_DATA_PATH=~/.steam/steam/steamapps/compatdata/489830 \
gamemoderun \
  steam-run \
    ~/.steam/steam/steamapps/common/Proton\ 7.0/proton \
    run ~/.steam/steam/steamapps/compatdata/489830/pfx/drive_c/users/steamuser/Desktop/SKSE.lnk