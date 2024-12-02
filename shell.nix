{
  pkgs ? import <nixpkgs> { },
  ...
}:
{
  default = pkgs.mkShell {
    NIX_CONFIG = "extra-experimental-features = nix-command flakes ca-derivations";
    packages = with pkgs; [
      nix
      home-manager
      git
    ];
  };
}
