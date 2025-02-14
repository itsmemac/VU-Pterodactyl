#!/bin/bash
cd /home/container

# Information output
echo "Running on Debian $(cat /etc/debian_version)"
echo "Current timezone: $(cat /etc/timezone)"
wine --version

# Make internal Docker IP address available to processes.
INTERNAL_IP=$(ip route get 1 | awk '{print $(NF-2);exit}')
export INTERNAL_IP

if [[ $XVFB == 1 ]]; then
    Xvfb :0 -screen 0 ${DISPLAY_WIDTH}x${DISPLAY_HEIGHT}x${DISPLAY_DEPTH} &
fi

# Install necessary to run packages
echo "First launch will throw some errors. Ignore them"

mkdir -p $WINEPREFIX

# Function to install MSI packages
install_msi() {
    local url=$1
    local filename=$(basename "$url")
    local logname="${filename%.*}_install.log"

    if [ ! -f "$WINEPREFIX/$filename" ]; then
        wget -q -O "$WINEPREFIX/$filename" "$url"
    fi

    wine msiexec /i "$WINEPREFIX/$filename" /qn /quiet /norestart /log "$WINEPREFIX/$logname"
}

# Install Gecko if required
if [[ $WINETRICKS_RUN =~ gecko ]]; then
    echo "Installing Gecko"
    WINETRICKS_RUN=${WINETRICKS_RUN/gecko}
    install_msi "http://dl.winehq.org/wine/wine-gecko/2.47.4/wine-gecko-2.47.4-x86.msi"
    install_msi "https://dl.winehq.org/wine/wine-gecko/2.47.4/wine-gecko-2.47.4-x86_64.msi"
fi

# Install Mono if required
if [[ $WINETRICKS_RUN =~ mono ]]; then
    echo "Installing Mono"
    WINETRICKS_RUN=${WINETRICKS_RUN/mono}
    install_msi "https://dl.winehq.org/wine/wine-mono/9.4.0/wine-mono-9.4.0-x86.msi"
fi

# List and install other packages
for trick in $WINETRICKS_RUN; do
    echo "Installing $trick"
    winetricks -q $trick
done

# Replace Startup Variables
MODIFIED_STARTUP=$(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')
echo ":/home/container$ ${MODIFIED_STARTUP}"

# Run the Server
eval ${MODIFIED_STARTUP}
