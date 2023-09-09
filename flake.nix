{
  description = "NixOS module for an xmonad session";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  }: let
    supportedSystems = [
      "aarch64-linux"
      "x86_64-linux"
    ];

    overlay = import ./nix/overlay.nix {};
  in
    flake-utils.lib.eachSystem supportedSystems (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          overlay
        ];
      };

      shell = pkgs.haskellPackages.shellFor {
        name = "xmonadrc-devShell";
        packages = p:
          with p; [
            xmonadrc
            xmobar-app
          ];
        withHoogle = true;
        buildInputs =
          (with pkgs; [
            haskell-language-server
            cabal-install
            zlib
          ])
          ++ (with pkgs.haskellPackages; [
            implicit-hie
          ]);

        shellHook = ''
          gen-hie --cabal > hie.yaml
        '';
      };
    in {
      devShells = {
        default = shell;
      };
      packages = rec {
        default = xmobar-app;
        xmobar-app = pkgs.haskellPackages.xmobar-app;
      };
    })
    // {
      nixosModules.default = {...}: {
        imports = [
          ./nix/xmonad-session
        ];
        nixpkgs.overlays = [
          overlay
        ];
      };
    };
}
