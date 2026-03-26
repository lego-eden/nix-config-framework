{ config, pkgs, lib, catppuccin, ... }:

let
  fromGitHub = ref: repo: pkgs.vimUtils.buildVimPlugin {
    pname = "${lib.strings.sanitizeDerivationName repo}";
    version = ref;
    src = builtins.fetchGit {
      url = "https://github.com/${repo}.git";
      ref = ref;
    };
  };
  slang-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "slang.nvim";
    version = "0.1.0";
    src = pkgs.fetchFromGitHub {
      owner = "pixelsandpointers";
      repo = "slang.nvim";
      tag = "0.1.0";
      hash = "sha256-xZNIG3Z9XpJpkDN6eww/ynZ9feU//yyDieub2Rm3Qv4=";
    };
    meta.description = "Slang LSP support for Neovim";
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
    gtk3.iconTheme.package = pkgs.adwaita-icon-theme;
    gtk3.iconTheme.name = "adwaita";

    gtk4.extraCss = extraCss;
    gtk4.iconTheme.package = pkgs.adwaita-icon-theme;
    gtk4.iconTheme.name = "adwaita";
  };

  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style.name = "kvantum";
  };

  qt.qt5ctSettings = {
    Fonts = {
      general = "\"Annotation Mono Demibold,12\"";
      fixed = "\"Annotation Mono Demibold,12\"";
    };
  };

  qt.qt6ctSettings = {
    Fonts = {
      general = "\"Annotation Mono Demibold,12\"";
      fixed = "\"Annotation Mono Demibold,12\"";
    };
  };

  catppuccin.kvantum = {
    enable = true;
    flavor = "mocha";
    accent = "flamingo";
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
      fidget-nvim
      slang-nvim
    ];
    extraLuaConfig = ''
      vim.opt.runtimepath:append("${pkgs.vimPlugins.nvim-treesitter.withAllGrammars}/runtime")
      ${lib.fileContents ./nvim/init.lua}
    '';
    extraPackages = with pkgs; [
      gcc
      clang-tools
      gnumake
      tree-sitter
      nodejs
      zls
      python3Packages.python-lsp-server
      jdt-language-server
      shader-slang
    ];
  };
}
