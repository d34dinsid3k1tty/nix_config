{ pkgs, lib, firefox-addons, buildFirefoxAddon, ... }:

{
  targets.genericLinux.enable = true;

  home.username = "michalina";
  home.homeDirectory = "/home/michalina";
  home.stateVersion = "26.05";

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "librewolf.desktop";
      "x-scheme-handler/http" = "librewolf.desktop";
      "x-scheme-handler/https" = "librewolf.desktop";
      "x-scheme-handler/about" = "librewolf.desktop";
      "x-scheme-handler/unknown" = "librewolf.desktop";
    };
  };
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
  home.sessionVariables = {
    BROWSER = "librewolf";
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

  # LibreWolf (Web)
  programs.librewolf = {
    enable = true;
    profiles.default = {
      extensions.packages = [
        # Cookies
        firefox-addons.cookie-editor
        firefox-addons.cookie-quick-manager

        # CSS/JS / Themes
        firefox-addons.stylus
        firefox-addons.violentmonkey
        (buildFirefoxAddon {
          pname = "doki-theme";
          version = "84.2.0";
          addonId = "{903b84bb-fd82-484e-8afd-c068b67679a7}";
          url = "https://addons.mozilla.org/firefox/downloads/file/3959037/doki_theme_for_firefox-84.2.0.xpi";
          sha256 = "f75be8ffe41c305e46791585510a58d7ac4e382047efab60f0ea90c741b289cf";
          meta = with lib; {
            description = "Doki THeme for Firefox";
            license = licenses.mit;
            homepage = "https://addons.mozilla.org/firefox/addon/doki-theme-for-firefox/";
          };
        })

        # Dark mode
        firefox-addons.darkreader

        # Developer Tools
        (buildFirefoxAddon {
          pname = "user-agent-switcher";
          version = "1.4.102";
          addonId = "user-agent-switcher@ninetailed.ninja";
          url = "https://addons.mozilla.org/firefox/downloads/file/4772478/uaswitcher-1.4.102.xpi";
          sha256 = "b83c36fe95d44ecd5dd8611b4af87390aa7b8c653d637b3bb287c152e63da8c8";
          meta = with lib; {
            description = "User-Agent Switcher and Manager";
            license = licenses.mpl20;
            homepage = "https://addons.mozilla.org/firefox/addon/user-agent-switcher-revived/";
          };
        })

        # Exporting
        firefox-addons.archivebox-exporter
        firefox-addons.export-cookies-txt
        firefox-addons.export-tabs-urls-and-titles

        # Flash
        firefox-addons.ruffle_rs

        # Legacy
        firefox-addons.old-reddit-redirect

        # News
        firefox-addons.rsshub-radar
        firefox-addons.rsspreview

        # Privacy/Telemetry
        firefox-addons.amp2html
        firefox-addons.canvasblocker
        firefox-addons.clearurls
        firefox-addons.istilldontcareaboutcookies
        firefox-addons.localcdn
        firefox-addons.multi-account-containers
        firefox-addons.redirector

        # Protocols
        firefox-addons.ipfs-companion

        # Search/search engines
        firefox-addons.add-custom-search-engine
        
        # Sidebar/Tabs
        firefox-addons.adaptive-tab-bar-colour
        firefox-addons.sidebery
        
        # Useful
        firefox-addons.fastforwardteam

        # Queer
        firefox-addons.shinigami-eyes

        # Videoplayer
        firefox-addons.nekocap

        # YouTube
        firefox-addons.annotations-restored
        firefox-addons.enhancer-for-youtube
        firefox-addons.return-youtube-dislikes
        firefox-addons.sponsorblock
        firefox-addons.youtube-recommended-videos
      ];

      settings = {
        # Browser general
        "browser.download.useDownloadDir" = false;
        "browser.search.suggest.enabled" = false;
        "browser.startup.page" = 3;
        "browser.shell.checkDefaultBrowser" = false;
        "keyword.enabled" = true;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

        # Pop-ups and related
        "dom.webnotifications.enabled" = false;
        "media.autoplay.default" = 5;

        # Tabs
        "browser.sessionstore.restore_on_demand" = true;
        "browser.tabs.closeWindowWithLastTab" = false;
        "browser.tabs.insertAfterCurrent" = true;

        # Privacy
        "extensions.formautofill.creditCards.enabled" = false;
        "extensions.formautofill.addresses.enabled" = false;
        "network.http.referer.XOriginPolicy" = 2;

        # UI
        "browser.toolbars.bookmarks.visibility" = "always";
        "findbar.highlightAll" = true;
        "ui.keymenuAccessKeyFocuses" = false;

        # Video/Hardware Acceleration
        "layers.acceleration.force-enabled" = true;
        "media.hardware-video-decoding.enabled" = true;
        "media.ffmpeg.vaapi.enabled" = true;
        "media.rdd-ffmpeg.enabled" = true;
        "widget.use-aspect-ratio" = true;

        # Session/Cookies
        "network.cookie.lifetimePolicy" = 0;
        "privacy.clearOnShutdown.cookies" = false;
        "privacy.clearOnShutdown.history" = false;

        # Sidebar
        "sidebar.revamp" = true;
      };

      # Extra configs
      # 1. Exceptions for websites cookies (1 - Allow cookies)
      extraConfig = ''
        user_pref("capability.policy.default.sites.https://github.com", 1);
      '';
    };
  };

  programs.home-manager.enable = true;
}

