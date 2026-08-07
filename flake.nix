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
        buildInputs = myApps;
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

