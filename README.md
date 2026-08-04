# 💽 Nix Config

Nix configuration for my ThinkPad X390 (odin)

[![Screenshot of odin](https://i.ibb.co/gZwjZ1Wr/image.png)](https://i.ibb.co/60bn0hty/image.png)

## ⌨️  Useful commands

```sh
# runs in nix shell
$ nix develop ~/nix_config --impure -c zsh
$ export XDG_DATA_DIRS="$NIX_BUILD_TOP/share:$XDG_DATA_DIRS"

# execute after updates in nix files
$ nix run github:nix-community/home-manager -- switch --flake .#michalina --impure
```

## 🔧 TODO

- [ ] Configurations for other machines
- [ ] Cleanup in config

## 🗒️  License

This config is unlicensed

