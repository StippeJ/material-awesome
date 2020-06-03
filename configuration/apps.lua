local filesystem = require('gears.filesystem')

-- Thanks to jo148 on github for making rofi dpi aware!
local with_dpi = require('beautiful').xresources.apply_dpi
local get_dpi = require('beautiful').xresources.get_dpi
local rofi_command = 'env /usr/bin/rofi -dpi ' .. get_dpi() .. ' -width ' .. with_dpi(400) .. ' -show drun -theme ' .. filesystem.get_configuration_dir() .. '/configuration/rofi.rasi -run-command "/bin/bash -c -i \'shopt -s expand_aliases; {cmd}\'"'

return {
  -- List of apps to start by default on some actions
  default = {
    terminal = 'gnome-terminal',
    rofi = rofi_command,
    lock = 'i3lock-fancy',
    quake = 'gnome-terminal',
    screenshot = '~/.config/awesome/configuration/utils/screenshot -f',
    region_screenshot = '~/.config/awesome/configuration/utils/screenshot -s',
    
    -- Editing these also edits the default program
    -- associated with each tag/workspace
    browser = 'firefox',
    editor = 'gedit', -- gui text editor
    social = 'flatpak run com.discordapp.Discord',
    game = rofi_command,
    files = 'nautilus -w',
    music = 'flatpak run com.spotify.Client'
  },
  -- List of apps to start once on start-up
  run_on_start_up = {
    -- 'xrandr --output HDMI-1 --mode 1920x1080 --rate 74.99', -- Adjust display settings
    -- 'xinput set-prop 13 355 1', -- Enable tapping for touchpad
    -- 'xinput set-prop 13 339 1', -- Enable natural scrolling for touchpad
    'compton --config ' .. filesystem.get_configuration_dir() .. '/configuration/compton.conf',
    'nm-applet --indicator', -- wifi
    --'pa-applet', -- shows an audiocontrol applet in systray when installed.
    --'blueberry-tray', -- Bluetooth tray icon
    --'xfce4-power-manager', -- Power manager
    'ibus-daemon --xim', -- Ibus daemon for keyboard
    'scream -u -p 4011 -i virbr1', -- scream audio sink
    'numlockx on', -- enable numlock
    '/usr/libexec/polkit-gnome-authentication-agent-1', -- Start Gnome-polkit-agent
    'gnome-keyring-daemon -s', -- Start Gnome-keyring-daemon
    --KDE '/usr/lib/x86_64-linux-gnu/libexec/polkit-kde-authentication-agent-1 & eval $(gnome-keyring-daemon -s --components=pkcs11,secrets,ssh,gpg)', -- credential manager
    -- MATE'/usr/lib/mate-polkit/polkit-mate-authentication-agent-1 & eval $(gnome-keyring-daemon -s --components=pkcs11,secrets,ssh,gpg)', -- credential manager
    -- Add applications that need to be killed between reloads
    -- to avoid multipled instances, inside the awspawn script
    '~/.config/awesome/configuration/awspawn' -- Spawn "dirty" apps that can linger between sessions
  }
}
