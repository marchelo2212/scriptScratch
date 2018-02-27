#!/bin/bash
# Autor Asus
if [ $EUID -ne 0 ]; then
   echo "Debes ejecutarlo como root (o mediante sudo)" 1>&2
   exit 1
fi

echo ">> Eliminando versiones anteriores..."
apt-get -y --purge remove adobeair
rm -rf /opt/adobe-air-sdk
rm /usr/share/applications/Scratch2.desktop

CHKBITS=`uname -m`
if [ $CHKBITS = "x86_64" ]; then
    echo ">> Instalando dependencias 32bit..."
    apt-get -q update
    apt-get -q -y install libgtk2.0-0:i386 libstdc++6:i386 libxml2:i386 libxslt1.1:i386 libcanberra-gtk-module:i386 gtk2-engines-murrine:i386 libqt4-qt3support:i386 libgnome-keyring0:i386 libnss-mdns:i386 libnss3:i386
fi

echo ">> Enlazando librerías de Gnome..."
ln -s /usr/lib/i386-linux-gnu/libgnome-keyring.so.0 /usr/lib/libgnome-keyring.so.0
ln -s /usr/lib/i386-linux-gnu/libgnome-keyring.so.0.2.0 /usr/lib/libgnome-keyring.so.0.2.0

echo ">> Descargando Adobe Air SDK..."
wget -q http://airdownload.adobe.com/air/lin/download/2.6/AdobeAIRSDK.tbz2
mkdir /opt/adobe-air-sdk
tar jxf AdobeAIRSDK.tbz2 -C /opt/adobe-air-sdk

echo ">> Descargando Air runtime/SDK desde Archlinux..."
wget -q https://aur.archlinux.org/cgit/aur.git/snapshot/adobe-air.tar.gz
tar xvf adobe-air.tar.gz -C /opt/adobe-air-sdk
chmod +x /opt/adobe-air-sdk/adobe-air/adobe-air

echo ">> Descargando Scratch2..."
mkdir /opt/adobe-air-sdk/scratch
wget -q -O /opt/adobe-air-sdk/scratch/scratch.air https://scratch.mit.edu/scratchr2/static/sa/Scratch-458.0.1.air

echo ">> Creando lanzador..."
unzip -j /opt/adobe-air-sdk/scratch/scratch.air icons/AppIcon128.png -d /opt/adobe-air-sdk/scratch/
cat << _EOF_ > /usr/share/applications/Scratch2.desktop
[Desktop Entry]
Encoding=UTF-8
Version=1.0
Type=Application
Exec=/opt/adobe-air-sdk/adobe-air/adobe-air /opt/adobe-air-sdk/scratch/scratch.air
Icon=/opt/adobe-air-sdk/scratch/AppIcon128.png
Terminal=false
Name=Scratch 2
Comment=Programación visual con Scatch 2.0
Categories=Application;Education;Development;ComputerScience;
MimeType=application/x-scratch-project
_EOF_
chmod +x /usr/share/applications/Scratch2.desktop

echo ">> FIN!"
