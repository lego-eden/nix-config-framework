{ config, pkgs, lib, ... }:

let
  fromGitHub = ref: repo: pkgs.vimUtils.buildVimPlugin {
    pname = "${lib.strings.sanitizeDerivationName repo}";
    version = ref;
    src = builtins.fetchGit {
      url = "https://github.com/${repo}.git";
      ref = ref;
    };
  };
in
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

  gtk =
    let
      extraCss = ''
        * {
          font-weight: 600; 
        }
      '';
    in {
    enable = true;
    colorScheme = "dark";
    # font.name = "MartianMono Nerd Font";
    font.name = "Annotation Mono";
    font.size = 16;
    
    gtk3.extraCss = extraCss;
    gtk4.extraCss = extraCss;
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    plugins = with pkgs.vimPlugins; [
      nvim-lspconfig
      nvim-treesitter
      catppuccin-nvim
      snacks-nvim
      nvim-metals
      blink-cmp
      rustaceanvim
    ];
    extraLuaConfig = ''
      vim.opt.runtimepath:append("${pkgs.vimPlugins.nvim-treesitter.withAllGrammars}/runtime")
      ${lib.fileContents ./nvim/init.lua}
    '';
    extraPackages = with pkgs; [
      gcc
      gnumake
      tree-sitter
      nodejs
    ];
  };
}
