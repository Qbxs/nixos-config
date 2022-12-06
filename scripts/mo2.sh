#! \bin\env bash
env \
  DOTNET_HOME=~/.steam/steam/steamapps/compatdata/489830/pfx/drive_c/windows/Microsoft.NET/Framework64/v4.0.30319 \
  PROTON_ENABLE_NVAPI=1 DXVK_CONFIG_FILE=~/.dxvk.conf \
  STEAM_COMPAT_CLIENT_INSTALL_PATH=/usr/games/steam \
  STEAM_COMPAT_DATA_PATH=~/.steam/steam/steamapps/compatdata/489830 \
steam-run \
  ~/.steam/steam/steamapps/common/Proton\ 7.0/proton \
  run ~/.steam/steam/steamapps/compatdata/489830/pfx/drive_c/Modding/MO2/ModOrganizer.exe