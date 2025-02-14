{ global, config, pkgs, self, ... }:

let
  inherit (global) username email;
  inherit (self) inputs;
  inherit (inputs) emacsmat;
  agda = pkgs.agda.withPackages (p: [ p.standard-library ]); 
in {
  imports = [
    ./modules/git.nix
    ./modules/dots.nix
    ./modules/fish.nix
    ./modules/dunst.nix
    ./modules/kitty.nix
    ./modules/starship.nix
    ./modules/autorandr.nix
    ./modules/alacritty.nix
    "${emacsmat}/emacsmat.nix"
  ];

  programs = {
    home-manager.enable = true;
    command-not-found.enable = true;
    direnv = {
      enable = true;
      nix-direnv = {
        enable = true;
        enableFlakes = true;
      };
    };
    fzf = {
      enable = true;
      enableFishIntegration = true;
    };
  };

  services = {
    clipmenu.enable = true;
    udiskie = {
      enable = true;
      automount = true;
      notify = true;
    };
  };

  home.packages = with pkgs; [
    # bar
    # haskellPackages.xmobar

    # chat
    tdesktop
    discord
    slack-dark

    # web
    firefox

    # office
    onlyoffice-bin

    # dev
#    agda

    # tools
    beekeeper-studio
    exercism
    docker-compose
    insomnia
    qbittorrent
    gitAndTools.gh
    exodus
    earthly
    awscli2
#    ngrok
    flyctl
    gcolor3
    t-rec
#    heroku

    # audio
    spotify

    # text
    jabref
    texlive.combined.scheme-full

    # images
    peek
    flameshot
    imagemagick

    # others
    any-nix-shell
    bitwarden-cli
    zoom-us
    arandr

    # DOOM Emacs dependencies
    binutils
    (ripgrep.override { withPCRE2 = true; })
    gnutls
    zstd
    editorconfig-core-c
    emacs-all-the-icons-fonts
  ];

  home.stateVersion = "21.05";
}
