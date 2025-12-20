#!/usr/bin/bash

set -e

errf() {
    printf "${@}" >&2 && exit 1
}

command-check() {
    local _name=${1}
    command -v ${_name} &>/dev/null || errf "command not found: ${_name}\n"
}

#################################################################################
# volume control
# https://wiki.archlinux.org/title/WirePlumber
#################################################################################

vol-get() {
    command-check wpctl
    local _id=${1}
    local _info=$(wpctl get-volume ${_id})
    local _integer=$(echo "${_info}" | awk -F'[. ]' '{ print $2 }')
    local _fraction=$(echo "${_info}" | awk -F'[. ]' '{ print $3 }')
    local _muted=$(echo "${_info}" | awk -F'[. ]' '{ print $4 }')
    local _label=""

    if [[ "${_muted}" == "[MUTED]" ]]; then
        _label=${_muted}
    else
        [[ "${_integer}" == "1" ]] && _label="100%" || _label="${_fraction}%"
    fi
    echo "${_label}"
}

vol-num() {
    command-check wpctl
    [[ "${1}" == "[MUTED]" ]] && echo "103" || echo "${1:0:-1}"
}

vol-down() {
    command-check wpctl
    wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
    wobctl.sh "$(vol-num $(vol-get @DEFAULT_AUDIO_SINK@))"
}

vol-up() {
    command-check wpctl
    wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
    wobctl.sh "$(vol-num $(vol-get @DEFAULT_AUDIO_SINK@))"
}

mute-toggle-speaker() {
    command-check wpctl
    wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
    wobctl.sh "$(vol-num $(vol-get @DEFAULT_AUDIO_SINK@))"
}

mute-toggle-mic() {
    command-check wpctl
    wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
}

sink-toggle() {
    command-check wpctl
    command-check jq
    local _sinkids=( $(pw-dump | jq '.[]|select(.info.props."media.class"=="Audio/Sink")|.id' | xargs) )
    local _currentid=$(wpctl inspect @DEFAULT_SINK@ | head -n 1 | cut -d, -f1 | cut -d' ' -f2)
    local _size=${#_sinkids[@]}
    local _index=-1
    local _targetid
    local _desc

    for _i in "${!_sinkids[@]}"; do
        if [[ "${_sinkids[$_i]}" == "${_currentid}" ]]; then
            _index=${_i}
            break
        fi
    done

    _index=$(( ${_index} + 1 ))
    (( _index >= _size )) && _index=0
    _targetid=${_sinkids[$_index]}
    _desc=$(pw-dump | jq -r --argjson id ${_targetid} '.[]|select(.id==$id)|.info.props."node.description"')

    wpctl set-default ${_targetid}
    notify-send -a $(basename $0) -t 2000 "Audio Sink" "${_desc}"
}

#################################################################################
# sway status
#################################################################################

scratchpad-count() {
    local _count=$(swaymsg -t get_tree | grep -c '"scratchpad_state": "fresh"')
    [[ "${_count}" =~ ^[1-9]+[0-9]*$ ]] && echo "[Scratch: ${_count}] " || echo ""
}

muted-label() {
    command-check wpctl
    local _label
    local _vol

    _vol="$(wpctl get-volume @DEFAULT_AUDIO_SINK@)"
    [[ "${_vol}" =~ MUTED ]] && _label="Speaker"

    _vol="$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@)"
    if [[ "${_vol}" =~ MUTED ]]; then
       [[ -n "${_label}" ]] && _label+=",Mic" || _label="Mic"
    fi

    [[ -n "${_label}" ]] && echo "[Muted:${_label}] " || echo ""
}

bar-status() {
    local _str
    while true; do
        _str=""
        _str+="$(scratchpad-count)"
        _str+="$(muted-label)"
        _str+="$(date '+%a %b.%d %H:%M')"
        printf "%s \n" "${_str}"
        sleep 0.1
    done
}

#################################################################################
# lock screen, suspend
#################################################################################

lock-screen() {
    command -v swaylock &>/dev/null || errf "command not found: swaylock\n"
    pidof swaylock || swaylock \
        --daemonize \
        --ignore-empty-password \
        --indicator-idle-visible \
        --indicator-radius 50 \
        --indicator-thickness 13 \
        --indicator-x-position 80 \
        --indicator-y-position 80 \
        --color 000000 \
        --scaling solid_color
}

lock-suspend() {
    lock-screen
    sleep 0.2
    systemctl suspend
}

#################################################################################
# screenshot
# https://github.com/OctopusET/sway-contrib
#################################################################################

grim-check() {
    command -v grim &>/dev/null || errf "command not found: grim\n"
}

grimshot-check() {
    command -v grimshot &>/dev/null || errf "command not found: grimshot\n"
}

_save_path=~/Pictures/Screenshot.$(date +%y%m%d.%H%M%S).$(date +%N|cut -c1).png

screenshot-fullscreen() {
    grim-check
    grim ${_save_path}
}

screenshot-area() {
    grim-check && grimshot-check
    grimshot savecopy area ${_save_path}
}

screenshot-window() {
    grim-check && grimshot-check
    grimshot savecopy window ${_save_path}
}

#################################################################################
# gsettings
#################################################################################

gsettings-check() {
    command -v gsettings &>/dev/null || errf "command not found: gsettings\n"
}

gsettings-icon() {
    gsettings-check
    local _name="${1}"
    [[ -n "${_name}" ]] || errf "icon theme undefined\n"
    [[ -d "/usr/share/icons/${_name}" ]] || errf "icon theme not found: ${_name}\n"
    gsettings set org.gnome.desktop.interface icon-theme "${_name}"
}

gsettings-gtk() {
    gsettings-check
    local _name="${1}"
    [[ -n "${_name}" ]] || errf "gtk theme undefined\n"
    [[ -d "/usr/share/themes/${_name}" ]] || errf "gtk theme not found: ${_name}\n"
    gsettings set org.gnome.desktop.interface gtk-theme "${_name}"
}

#################################################################################
# apps
#################################################################################

terminal() {
    foot
    # alacritty
}

dynamic-menu() {
    wmenu-run -b -f 'monospace bold 18'
}

#################################################################################
# dispatcher
#################################################################################

case "${1}" in
    "")
        printf "Usage: $(basename $0) <function_name>\n"
        printf "function_name:\n"
        declare -F | awk '{print "  " $3}'
        ;;
    *)
        _command="${1}"
        shift
        ${_command} "${@}"
        ;;
esac

