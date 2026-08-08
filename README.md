# 💽 Nix Config

Nix configuration for my ThinkPad X390 (odin)

**⚠️ Config created by Nix newbie, be careful & gentle**

[![Screenshot of odin](https://i.ibb.co/gZwjZ1Wr/image.png)](https://i.ibb.co/60bn0hty/image.png)

## ⌨️  Useful commands

Before running config, don't forget to fix SSL:

```sh
$ sudo mkdir -p /etc/ssl/certs
$ sudo ln -sf /etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem /etc/ssl/certs/ca-bundle.crt
```

To deal with nix environment:

```sh
# runs in nix shell
$ nix develop ~/nix_config --impure -c zsh
$ export XDG_DATA_DIRS="$NIX_BUILD_TOP/share:$XDG_DATA_DIRS"

# execute after updates in nix files
$ NIXPKGS_ALLOW_UNFREE=1 nix run github:nix-community/home-manager -- switch --flake .#michalina --impure
```

Actually you must enable LibreWolf extensions manually.

Also, Window List GNOME Extension must be activated manually too,
rest of them are activates automatically

Custom GNOME extension not in config due to not being in Nix repostitory
or not working automatically (nor shown in list):

- [Add to Desktop](https://extensions.gnome.org/extension/3240/add-to-desktop/)
- [Current Workspace Name](https://extensions.gnome.org/extension/8233/current-workspace-name/)
- [Emoji Copy](https://extensions.gnome.org/extension/6242/emoji-copy/)
- [In Picture](https://extensions.gnome.org/extension/8692/in-picture/)
- [Smart Home](https://extensions.gnome.org/extension/7737/smart-home/)
- [Software Hub](https://extensions.gnome.org/extension/10402/software-hub/)
- [User Name Indicator](https://extensions.gnome.org/extension/9829/user-name-indicator/)
- [User style sheet](https://extensions.gnome.org/extension/3414/user-stylesheet-font/)
- [V-Shell](https://extensions.gnome.org/extension/5177/vertical-workspaces/)

## 🔧 TODO

- [ ] Add rest of used GNOME extensions and add them programically
- [ ] Configurations for other machines
- [ ] Cleanup in config
- [ ] Improve config;pp

## 🗒️  License

This config is unlicensed

