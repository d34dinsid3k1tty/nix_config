{
  description = "My Nix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, firefox-addons, ... }:
    let
      system = "x86_64-linux";
      username = "michalina";
      pkgs = import nixpkgs {
        inherit system;
        config = {
          android_sdk.accept_license = true;
          allowUnfree = true;
        };
      };

      myApps = import ./shell.nix { inherit pkgs; };
    in {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = myApps ++ (with pkgs; [
          # GNOME
          gnomeExtensions.blur-my-shell
          gnomeExtensions.appindicator
        ]);

        shellHook = ''
          export GDK_BACKEND="wayland"
          export QT_QPA_PLATFORM="wayland"
          export NIXOS_OZONE_WL=1
          export SDL_VIDEODRIVER="wayland"
          export CLUTTER_BACKEND="wayland"

          export ANDROID_HOME="$HOME/Android/Sdk"
          export ANDROID_SDK_ROOT="$HOME/Android/Sdk"
          export FLUTTER_ANDROID_STUDIO_PATH="${pkgs.android-studio}"
        '';
      };

      homeConfigurations."${username}" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        extraSpecialArgs = {
          firefox-addons = firefox-addons.packages.${system};
          buildFirefoxAddon = firefox-addons.lib.${system}.buildFirefoxXpiAddon;
        };

        modules = [ ./home.nix ];
      };
    };
}

