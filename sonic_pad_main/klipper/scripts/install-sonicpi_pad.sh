#!/bin/bash

SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
CSPATH=$(sed 's/\/scripts//g' <<< $SCRIPTPATH)
CSENV="${CREALITY_VENV:-${HOME}/.creality-env}"
PYTHON="python3-virtualenv virtualenv python3-distutils"

sudo mkdir /mnt/app/
sudo mkdir /mnt/exUDISK/
sudo mkdir /mnt/SDCARD/
sudo mkdir /mnt/UDISK/
sudo mkdir /mnt/USB/
sudo mkdir /mnt/overlay/
sudo mkdir /mnt/rom/
sudo cp -rp ./klipper/resources/usr/res/ usr/
sudo chown -R root:root /usr/res/
sudo cp -rp ./klipper/resources/usr/share/libubox/ /usr/share/
sudo chown -R root:root /usr/share/libubox/
sudo cp -rp ./klipper/resources/usr/share/licenses/ /usr/share/
sudo chown -R root:root /usr/share/licenses/
sudo cp -rp ./klipper/resources/usr/share/localslicer/ /usr/share/
sudo chown -R root:root /usr/share/localslicer/
sudo cp -rp ./klipper/resources/usr/share/mjpg-streamer /usr/share/
sudo chown -R root:root /usr/share/mjpg-streamer/
sudo cp -rp ./klipper/resources/usr/share/opencv4/ /usr/share/
sudo chown -R root:root /usr/share/opencv4/
sudo cp -rp ./klipper/resources/usr/share/web/ /usr/share/
sudo chown -R root:root /usr/share/web/
sudo cp -rp ./klipper/resources/usr/share/usb.ids.gz /usr/share/
sudo chown -R root:root /usr/share/usb.ids.gz

create_virtualenv()
{
    echo_text "Creating virtual environment"
    if [ ! -d ${CSENV} ]; then
        GET_PIP="${HOME}/get-pip.py"
        virtualenv --no-pip -p /usr/bin/python3 ${CSENV}
        curl https://bootstrap.pypa.io/pip/3.6/get-pip.py -o ${GET_PIP}
        ${CSENV}/bin/python ${GET_PIP}
        rm ${GET_PIP}
    fi

    source ${CSENV}/bin/activate
    while read requirements; do
        pip --disable-pip-version-check install $requirements
        if [ $? -gt 0 ]; then
            echo "Error: pip install exited with status code $?"
            echo "Unable to install dependencies, aborting install."
            deactivate
            exit 1
        fi
    done < ${CSPATH}/scripts/Creality-requirements.txt
    deactivate
    echo_ok "Virtual enviroment created"
}

modify_user()
{
    sudo usermod -a -G tty $USER
}

if [ "$EUID" == 0 ]
    then echo_error "Plaease do not run this script as root"
    exit 1
fi
create_virtualenv
modify_user
echo_ok "SonicPi was installed"
