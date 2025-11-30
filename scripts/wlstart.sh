#!/usr/bin/bash

command -v fcitx5 &>/dev/null && \
    ! pidof fcitx5 &>/dev/null && fcitx5 -d -r

polkit_name=polkit-gnome-authentication-agent-1
polkit_exec=/usr/lib/polkit-gnome/${polkit_name}
command -v ${polkit_exec} &>/dev/null && \
    ! pidof ${polkit_name} &>/dev/null && \
        ${polkit_exec} 2>&1 &

command -v kanshi &>/dev/null && \
    ! pidof kanshi &>/dev/null && \
        kanshi 2>&1 &
