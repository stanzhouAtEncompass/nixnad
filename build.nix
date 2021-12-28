let
  inherit (builtins) getFlake;
  flake = getFlake "${toString ./.}";
  inherit (flake.outputs) pkgs;
in builtins.attrValues {
  inherit (pkgs) discord neovim;
  inherit (flake.outputs.nixosConfigurations)
    k6-nix
    bootstrap
  ;
  inherit (flake.outputs.homeConfigurations) main;
}
