#!/usr/bin/env bash
env \
  ENABLE_VKBASALT=1 \
  PROTON_ENABLE_NVAPI=1 \
  PROTON_HIDE_NVIDIA_GPU=0 \
  DXVK_CONFIG_FILE=~/Modding/dxvk.conf \
  STEAM_COMPAT_CLIENT_INSTALL_PATH=/usr/games/steam  \
  STEAM_COMPAT_DATA_PATH=~/.steam/steam/steamapps/compatdata/489830 \
gamemoderun \
  steam-run \
    ~/.steam/steam/steamapps/common/Proton\ -\ Experimental/proton \
    run ~/.steam/steam/steamapps/compatdata/489830/pfx/drive_c/users/steamuser/Desktop/SKSE.lnk