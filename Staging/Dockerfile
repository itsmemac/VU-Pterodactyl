# ---------------------------------------
#        Venice Unleashed Wine Egg
# ---------------------------------------
FROM    ghcr.io/parkervcp/yolks:debian

LABEL   author="Mac" maintainer="me@itsmemac.com"

## Install required packages
RUN dpkg --add-architecture i386 \
        && apt update -y \
        && apt install -y --no-install-recommends \
        gnupg2 \
        tzdata \
        software-properties-common \
        libntlm0 \
        winbind \
        xvfb \
        xauth \
        python3 \
        libncurses5:i386 \
        libncurses6:i386 \
        && rm -rf /var/lib/apt/lists/*

# Add WineHQ repository securely
RUN mkdir -p /etc/apt/keyrings \
        && wget -nc -O /etc/apt/keyrings/winehq.gpg https://dl.winehq.org/wine-builds/winehq.key \
        && echo "deb [signed-by=/etc/apt/keyrings/winehq.gpg] https://dl.winehq.org/wine-builds/debian/ bullseye main" > /etc/apt/sources.list.d/winehq.list

# Add OpenSUSE Wine repository securely
RUN wget -qO- https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/Debian_11/Release.key | gpg --dearmor -o /etc/apt/keyrings/wine-obs.gpg \
        && echo "deb [signed-by=/etc/apt/keyrings/wine-obs.gpg] http://download.opensuse.org/repositories/Emulators:/Wine:/Debian/Debian_11 ./" > /etc/apt/sources.list.d/wine-obs.list

# Install WineHQ with recommended dependencies
RUN apt update \
        && apt install -y --install-recommends winehq-staging cabextract xvfb \
        && rm -rf /var/lib/apt/lists/*

# Set up Winetricks
RUN wget -q -O /usr/sbin/winetricks https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks \
        && chmod +x /usr/sbin/winetricks

ENV HOME=/home/container
ENV WINEPREFIX=/home/container/.wine
ENV WINEDLLOVERRIDES="mscoree,mshtml="
ENV DISPLAY=:0
ENV DISPLAY_WIDTH=1024
ENV DISPLAY_HEIGHT=768
ENV DISPLAY_DEPTH=16
ENV AUTO_UPDATE=1
ENV XVFB=1

USER container
WORKDIR /home/container

COPY ./entrypoint.sh /entrypoint.sh
CMD ["/bin/bash", "/entrypoint.sh"]