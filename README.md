# waylabrc

Minimal out-of-box configurations for
[Sway](https://swaywm.org) and
[Labwc](https://labwc.github.io/index.html).

## Dependencies

Following packages are needed to be installed for corresponding functions working:

[swaylock](https://github.com/swaywm/swaylock)
lock screen

[WirePlumber](https://wiki.archlinux.org/title/WirePlumber#Keyboard_volume_control)
(`wpctl` command for volume control)

[wob](https://github.com/francma/wob)
(volume indicator bar)

[grim](https://gitlab.freedesktop.org/emersion/grim)
, [sway-contrib](https://github.com/OctopusET/sway-contrib)
(`grimshot` helper for screenshot)

## Usage

"Clone repo and add scripts to PATH:

```
$ git clone https://github.com/undus5/waylabrc.git ~/waylabrc
$ ln -s ~/waylabrc/scripts/*.sh /usr/local/bin/
$ ln -s ~/waylabrc/sway ~/.config/sway
$ ln -s ~/waylabrc/labwc ~/.config/labwc
```

## Sway Keybindings (Partial)

`Super` equals `Win` key.

Launching apps:

`Super + d`      menu for launching app\
`Super + Return` open terminal emulator, alacritty

General control:

`Super + Ctrl + Escape`  exit sway\
`Super + Ctrl + Return`  reload sway\
`Super + Shift + Escape` kill focused window

`Super + f` toggle window fullscreen\
`Super + g` toggle status bar showing

Focus onto direction:

`Super + h` focus left\
`Super + j` focus down\
`Super + k` focus up\
`Super + l` focus right

Move window to direction:

`Super + Shift + h` move to left\
`Super + Shift + j` move to down\
`Super + Shift + k` move to up\
`Super + Shift + l` move to right

Focus on specific workspace:

`Super + 1/2/3/4/5/6/7/8/9/0`\
`Super + q/w/e/r/t/y/u/i/o/p`
`Super + z/x/c/v/b/n/m`

Move window to specific workspace:

`Super + Shift + 1/2/3/4/5/6/7/8/9/0`\
`Super + Shift + q/w/e/r/t/y/u/i/o/p`
`Super + Shift + z/x/c/v/b/n/m`

Focus onto display:

`Super + [` focus on left display\
`Super + ]` focus on right display

Move window to display:

`Super + Shift + [` move to left display\
`Super + Shift + ]` move to right display

Layout toggle:

`Super + =` switch to stacking layout\
`Super + \` toggle split layout between horizontal and vertical

`Super + ;` splitv, split next window to vertical layout\
`Super + '(single quote)` splith, split next window to horizontal layout

Volume control:

`Super + ,`         volume -5%\
`Super + .`         volume +5%\
`Super + /`         toggle speaker mute\
`Super + Alt + /`   toggle microphone mute\
`Super + Shift + /` toggle speakers (audio sinks)

Screenshot:

`Super + grave(backtick)` take screenshot for selected area\
`Print` take screenshot fullscreen

Session control:

`Super + Shift + grave(backtick)` lock screen

## Labwc Keybindings

Launching apps: same as sway

Volume control: same as sway

`Super + Up/Down/Left/Right` snap window to edge of screen, toggle

`Alt + Tab` list and switch running app

`Super + Space` open right click menus

Suspend, poweroff, reboot and screenshot are in right click menus.

## CapsLock as Ctrl

`CapsLock` is remapped as `Ctrl`, `Numlock` is enabled by default.

