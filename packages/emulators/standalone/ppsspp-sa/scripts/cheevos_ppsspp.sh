#! /bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2022-present Hector Calvarro (https://github.com/kelvfimer)
# Copyright (C) 2024-present ROCKNIX (https://github.com/ROCKNIX)

. /etc/profile

PPSSPP_ACHIEVEMENTS="/storage/.config/ppsspp/PSP/SYSTEM/ppsspp_retroachievements.dat"
PPSSPP_INI="/storage/.config/ppsspp/PSP/SYSTEM/ppsspp.ini"

username=$(get_setting "global.retroachievements.username")
password=$(get_setting "global.retroachievements.password")
token=$(get_setting "global.retroachievements.token")

#Test the token if empty exit 1.
if [ -z "${token}" ]
then
      echo "Token is empty you must log in retroachievements first in Emulation Station" > /var/log/cheevos.log
      exit 1
fi
echo "${token}" > ${PPSSPP_ACHIEVEMENTS}

#Variables for checking if [Cheevos] or enabled true or false are presente.
zcheevos=$(grep -Fx "[Achievements]" ${PPSSPP_INI})
datets=$(date +%s%N | cut -b1-13)

if ([ -z "${zcheevos}" ])
then
    echo -e "[Achievements]\nAchievementsEnable = True\nAchievementsUserName = ${username}\n" >> ${PPSSPP_INI}
else
    sed -i '/^AchievementsEnable =/c\AchievementsEnable = True' ${PPSSPP_INI}
    if ! grep -q "^AchievementsUserName = " ${PPSSPP_INI}; then
        sed -i "/^\[Achievements\]/a AchievementsUserName = ${username}" ${PPSSPP_INI}
    else
        sed -i "/^\[Achievements\]/,/^\[/{s/^AchievementsUserName = .*/AchievementsUserName = ${username}/;}" ${PPSSPP_INI}
    fi
fi
