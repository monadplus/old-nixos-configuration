# DEPRECATED

> I have been using Arch Linux since 2020, while still using Nix for side projects.
> I still think Nix is the only sensible way to manage software today.
> I will come back to NixOS soon..

First, you need to install a fresh NixOS following the [manual](https://nixos.org/nixos/manual/index.html#sec-installation).

Then, you need to have `git` on the system.
If installing is required do `nix-env -iA pkgs.git`.
You will need to import your github private key (or create a new one `ssh-keygen -t rsa -b 4096 -C "arnauabella@gmail.com"`)
and it to openSSH daemon `ssh-add /home/arnau/.ssh/github`.

```bash
# ! Backup your /etc/nixos/hardware-configuration.nix

$ sudo rm -r /etc/nixos
$ sudo git clone git@github.com:monadplus/nixconfig.git /etc/nixos
```

Before realising your configuration you must add (test if you really need it) home-manager channels:

```bash
$ nix-channel --add https://github.com/rycee/home-manager/archive/release-XX.XX.tar.gz home-manager
$ nix-channel --update
```

To install everything:

```bash
# This will take a long time (about 10-20')
$ sudo nixos-rebuild switch
$ reboot
```

## Command-lines

### Terminal emulator

- __Konsole__: my personal choice.
- __Alacritty__: I couldn't manage to configure very basic shortcuts like clear history.

### Monitors

Just plug your screen and run `autorandr -c`

`arandr` is the graphical version of `xrandr` (use this one.)

`xrandr` (cli):

```bash
xrandr # List monitors and options
xrandr --auto # Detect monitors and connect them
xrandr --output HDMI-1 --off # Disable hdmi monitor
xrandr --output HDMI-1 --right-of eDP-1  # Place HDMI-1 at the right
# ^^^^^^ To change mirror monitoring
```

We installed `autoxrandr` to change config when hardware changes.

It requires a bit of configuration to automatically work ! (read https://github.com/phillipberndt/autorandr#how-to-use)

On `home.nix` we set up a declarative autorandx.

### Monitors backlight

https://wiki.archlinux.org/index.php/Backlight#External_monitors

### Wi-fi

Known networks are set on configuration.nix

wpa_gui: GUI, simple to use.

wpa_cli:

```
$ wpa_cli
> scan
OK
<3>CTRL-EVENT-SCAN-RESULTS
> scan_results
bssid / frequency / signal level / flags / ssid
00:00:00:00:00:00 2462 -49 [WPA2-PSK-CCMP][ESS] MYSSID
11:11:11:11:11:11 2437 -64 [WPA2-PSK-CCMP][ESS] ANOTHERSSID

# If the SSID does not have password authentication, you must explicitly configure the network as keyless by replacing the command

> save_config
OK
> quit
```

### Audio

alsamixer

We set up keybinding to automatically increase/decrease the volume.

The volume for the bluetooth headsets doesn't work.

### Bluetooth

`blueman-manager` (gui) / blueman-applet (daemon)

Command line:

```
$ bluetoothctl
[bluetooth] # power on
[bluetooth] # agent on
[bluetooth] # default-agent
[bluetooth] # scan on
...put device in pairing mode and wait [hex-address] to appear here...
[bluetooth] # pair [hex-address]
[bluetooth] # connect [hex-address]
```

`pavucontrol` to manage bluetooth devices configuration.

### Markdown reader

`typora`

### Browser

`firefox` and `chromium`

### Epub, PDF, Xps

`zathura`

### Disk managers

Partitions: `$ parted`

To display partitions: `$ sudo parted -l`

Disk space usage analyzer: `$ ncdu`

### VPN

`$ openvpn`

### Touchpad

Touchpad configuration is managed by [libinput](https://wiki.archlinux.org/index.php/Libinput).

The configuration is managed in a declarative way.

How to change the sensivity:

```bash
$ xinput list # Search for TouchPad id
$ xinput --list-props ID # From the previous list
$ xinput --set-prop ID "libinput Accel Speed" 0.3 # 0.3 is just an example
```

### Screenshots

Managed by `scrot`.

Hotkeys:

- `PtrSc`
- `Ctrl + PtrSc`

### Clibpard manager

[clipmenu](https://github.com/cdown/clipmenu)

Requires a systemd daemon runnning: `clipmenud`

And then you can access the tray: `https://github.com/cdown/clipmenu`

I remapped _clipmenu_ to `Ctrl+Shift+V` via xmonad.

### Images

```bash
$ nomacs <<image.jpg>>
```

### Translate CLI

We use `translate-shell` for that:

```
trans -s es -t en   word | multiple words | "this is a sentence."
```

`translate-shell` is configured via the dotfile _~/.translate-shell/init.trans_.

### BitTorrent

Open [transmission](https://github.com/transmission/transmission) at <http://localhost:9091/transmission/web/>

Open it via [transgui](https://github.com/transmission-remote-gui/transgui).

Transmission daemon can be controlled via the RPC interface using transmission-remote or the WebUI (http://localhost:9091/ by default).

## Xmonad

Xmonad configuration can be found at `./dotfiles/xmonad/xmonad.hs` and it's configured via nixos (i.e. there is no need to symlink it to ~/.xmonad/).

xmonad top bar is a plug-in called `xmobar` and it is configured with it own config file: `~/.xmobarrc` (can be found on ./dotfiles/xmonad/.xmobarrc)

## GPG

Files protected with GPG have the extension `.gpg`.  In order to encrypt/decrypt them:

```bash
# Encrypt
gpg -c filename

# Decrypt
gpg filename.gpg
```
