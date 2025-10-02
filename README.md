# This Pterodactyl Egg doesn't work anymore due to changes in EA Auth and Wine . Use the [Official VU Pterodactyl/Pelican Egg](https://github.com/pelican-eggs/games-standalone/tree/main/venice_unleashed) instead for updated and working version of this Egg

# [Venice Unleashed](https://veniceunleashed.net/) - Pterodactyl Egg and Docker Image

![License](https://img.shields.io/github/license/itsmemac/VU-Pterodactyl?style=plastic/badge.svg) ![Stable](https://github.com/itsmemac/VU-Pterodactyl/actions/workflows/stable.yml/badge.svg) ![Staging](https://github.com/itsmemac/VU-Pterodactyl/actions/workflows/staging.yml/badge.svg)

Repository contains latest version of Venice Unleashed Egg for your [Pterodactyl panel](https://pterodactyl.io/) and Docker Image so you can create VU servers easily and have a working server in few seconds

This uses Wine yolk format of [Pelican/Parkervcp](https://github.com/pelican-eggs/yolks/tree/master/wine)

## ABOUT VU
Experience Battlefield 3 like never before
VU /vi:ju:/ is a community-oriented Battlefield 3 modding platform that gives you back control of your gaming experience.

## PREREQUISITES
 - Venice Unleashed Account linked to EA/Origin Account. [Refer here on how to link](https://docs.veniceunleashed.net/general/playing/#creating-an-account-and-linking-your-origin-account)
 - Server key generated from Venice Unleashed [key management portal](https://veniceunleashed.net/keys) (Download the generated key file)
 - Copy of Battlefield 3 (full and up-to-date installation)
 - Token generated using `-activate -lsx` as launch aurgument in windows VU instance [Refer Here](https://docs.veniceunleashed.net/hosting/setup-win/#activating-the-game) (Token is shown on the screen)

## PORTS

 - 3 Ports are required to run Venice Unleashed servers
 - Primary port is automatically assigned as game port for the server
 - Harmony services and RCON needs port assigned in the Startup tab

|  Port   |      Default Ports      |
|---------|-------------------------|
|  Game   |  Primary Port of server |
| Harmony |           7948          |
|  RCON   |          47200          |

## STARTUP COMMAND

    if [ ! -f /home/container/activated ]; then wine ~/vu/client/vu.com -gamepath ~/bf3 -activate -ea_token ${AUTHTOKEN}; touch /home/container/activated; else wine ~/vu/client/vu.com -gamepath ~/bf3 -serverInstancePath "$(winepath -w ~/vu/instance)" -server -dedicated -${FREQUENCY} -listen 0.0.0.0:$SERVER_PORT -mHarmonyPort ${HARMONY} -RemoteAdminPort 0.0.0.0:${RCON}; fi    

## EGG VARIANT

There is 2 variants of Eggs for Venice Unleashed
- With mount
- Without mount

### WITH MOUNT

In order to reduce size of server, **/bf3** directory is shared with multiple servers rather than having it in root directory of each server.

This type of egg uses mount feature of Pterodactyl where you need to create a mount for **/bf3** directory and mount it to server.
Refer to this [link](https://pterodox.com/guides/mounts.html)  for more info on how to create mounts in Pterodactyl Panel

Below example shows BF3 game files mount hosted in source path `/var/lib/pterodactyl/mounts/bf3` which has required BF3 game files
![Mounts](https://i.postimg.cc/mgrmVL5t/image.png)

**Recommended disk size** : 3GB (Uses about 1.6GB after initial startup without any mods)

### WITHOUT MOUNT

This type of server uses more than 35GB in space where you have to upload the BF3 game files for each server under **/bf3** directory.

**Recommended disk size** : 45GB (Including BF3 game files which is ~35GB. Can vary between regions)

## NOTES

- Server takes sometime to mark as running status since server has to connect to Zeus backend for listing. Wait for this message in console [Game successfully registered with Zeus. The server is now accepting connections.]
- Token generated using `-activate -lsx` from Windows PC should be provided in startup before starting the server.
- Tokens do expire after usage so you can't use the same token twice.
- Before you start the server, transfer the key downloaded from VU key management portal to `~/vu/instance` directory, and name it `server.key`
- If you start the server with default credentials, server will create `activated` file in your server directory with default credentials and server will not work. Delete `activated` file, provide your credentials in startup and restart server to activate.
- 2FA should be disabled in your EA Account to successfully verify the installation (You can enable 2FA after activation)
- Mount should be linked to the egg for mounts to work (Edit the mount and assign it to VU with mount Egg as shown in below image)
![mount-edit.jpg](https://i.postimg.cc/NfdQNwt5/mount-edit.jpg)
- Mount should also be mounted in mount tab of server settings for each servers you wish to have mount available
- Egg includes both stable and staging version of Wine which you can change in Startup tab of the server. Both works fine with current versions of VU but i recommend Staging version since it has to recent bugfixes but if you face any issues, use Stable version.
- Auto Update is disabled by default due to ongoing issue with VU auto updater causing issue with server startup. Investigating the root cause of the issue. Till then, disabling it.

