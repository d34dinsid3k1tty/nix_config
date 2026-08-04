{ pkgs ? import <nixpkgs> {} }:

[
  # CLIs
  pkgs.aria2
  pkgs.btop

  # CLIs - games/text gens
  pkgs.blahaj
  pkgs.bsdgames
  pkgs.cbonsai
  pkgs.ponysay

  # Programming
  pkgs.bun
  pkgs.docker
  pkgs.docker-compose
  pkgs.flutter
  pkgs.git
  pkgs.go
  pkgs.haxe
  pkgs.jdk21
  pkgs.jdk17
  pkgs.jdk8
  pkgs.love
  pkgs.mercurial
  pkgs.meson
  pkgs.ninja

  # Security
  pkgs.gnupg
  pkgs.pinentry-gnome3

  # Utils
  pkgs.unzip
]

