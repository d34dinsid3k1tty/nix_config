{ pkgs, lib, ... }:

{
  targets.genericLinux.enable = true;

  home.username = "michalina";
  home.homeDirectory = "/home/michalina";
  home.stateVersion = "26.05";

  xdg.mimeApps.enable = true;
  xdg.mime.enable = true;
  xdg.enable = true;

  home.packages = [
    # Emulators
    pkgs.dosbox-x
    pkgs.mesen
    pkgs.openmsx 

    # Messengers
    pkgs.discord-canary
    pkgs.ferdium
    pkgs.pidgin
    pkgs.stoat-desktop
    pkgs.telegram-desktop
    pkgs.element-desktop

    # Programming
    pkgs.android-studio-full
    pkgs.dbeaver-bin
    pkgs.godot
    pkgs.vscode
  ];
  home.shellAliases = {
    element-desktop = "element-desktop --password-store=\"gnome-libsecret\"";
  };

  home.activation.linkDesktopAndIcons = lib.hm.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD mkdir -p $HOME/.local/share/applications $HOME/.local/share/icons

    # Link desktop files
    if [ -d "$HOME/.nix-profile/share/applications" ]; then
      $DRY_RUN_CMD ln -sf $HOME/.nix-profile/share/applications/*.desktop $HOME/.local/share/applications/ 2>/dev/null || true
    fi

    # Link icon files
    if [ -d "$HOME/.nix-profile/share/icons" ]; then
      $DRY_RUN_CMD ln -sf $HOME/.nix-profile/share/icons/* $HOME/.local/share/icons/ 2>/dev/null || true
    fi
  '';

  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "michalina";
        email = "me@michalina.fyi";
      };

      commit = {
        gpgsign = true;
      };

      signing = {
        key = "DCB196A119FB2D936E76E6475051DA7EAF54ABE3";
        signByDefault = true;
      };
    };
  };

  programs.gpg = {
    enable = true;
    publicKeys = [
      {
        text = builtins.readFile "/home/michalina/.secrets/me@michalina.fyi_public.asc";
        trust = "ultimate";
      }
    ];
  };
  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-gnome3;
  };

  home.activation.importGpgKey = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ -f $HOME/.secrets/me@michalina.fyi_private.asc ]; then
      ${pkgs.gnupg}/bin/gpg --import "/home/michalina/.secrets/me@michalina.fyi_private.asc"
    fi
  '';

  # Programs with configuration
  # Thunderbird (E-mail)
  programs.thunderbird = {
    enable = true;
    profiles.default = {
      isDefault = true;

      settings = {
        # Enable userChrome.css and userContent.css
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

        # Privacy
        "privacy.donottrackheader.enabled" = true;
        "network.cookie.cookieBehavior" = 1;

        # UI
        "mailnews.start_page_enabled" = false;
        "mail.biff.play_sound" = false;
        "mail.openMessageBehavior.version" = 1;
      };
    };
  };

  programs.home-manager.enable = true;
}

