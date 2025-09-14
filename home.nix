{ config, pkgs, ... }:

{
  # Home manager nees a bit of information about you and the paths it should manage
  home.username = "legoeden";
  home.homeDirectory = "/home/legoeden";

  # This value determines the Home Manager release that your configuration is compatible with. This helps avoid breakage when a new Home manager release introduces backwards incompatible changes.
  # You can update home manager without changing this value. See the home manager release notes for list of state version changes in each release.
  home.stateVersion = "25.05";

  # Let Home manager install and manage itself.
  programs.home-manager.enable = true;

  home.pointerCursor = {
    enable = true;
    x11.enable = true;
    gtk.enable = true;
    sway.enable = true;
    hyprcursor.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
  };

  gtk = {
    enable = true;
    colorScheme = "dark";
    font.name = "MartianMono Nerd Font";
    font.size = 14;
  };
}