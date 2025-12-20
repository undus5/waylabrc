#!/usr/bin/bash

command -v kanshi &>/dev/null \
    && ! pidof kanshi &>/dev/null \
    && nohup kanshi &>/dev/null &

command -v fcitx5 &>/dev/null \
    && ! pidof fcitx5 &>/dev/null \
    && nohup fcitx5 -d -r &>/dev/null &

polkit_name=polkit-gnome-authentication-agent-1
polkit_exec=/usr/lib/polkit-gnome/${polkit_name}
command -v ${polkit_exec} &>/dev/null \
    && ! pidof ${polkit_name} &>/dev/null \
    && nohup ${polkit_exec} &>/dev/null &

command -v wlstart-custom.sh &>/dev/null \
    && nohup wlstart-custom.sh &>/dev/null &

