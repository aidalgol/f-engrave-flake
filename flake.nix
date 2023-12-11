{
  description = "F-Engrave Nix shell";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.platforms.all;
    pkgsFor = system: nixpkgs.legacyPackages.${system};

    version = "1.75";
    srcFor = system:
      (pkgsFor system).fetchzip {
        url = "https://www.scorchworks.com/Fengrave/F-Engrave-${version}_src.zip";
        hash = "sha256-aMchmn6B0VfpBiOTbXM6MDmLfAn7iLPI2oF0B36ttDo=";
      };
  in {
    devShells = forAllSystems (system: let
      pkgs = pkgsFor system;
    in {
      default = pkgs.mkShell {
        packages = with pkgs; [
          nil # Nix LS
          self.packages.${system}.ttf2xcf_stream
          potrace
          (python3.withPackages (pypkgs: [
            pypkgs.python-lsp-server
            pypkgs.tkinter
            pypkgs.pillow
            pypkgs.pyclipper
          ]))
        ];

        shellHook = ''
          # Copy the f-engrave.py script from source into the working directory
          # if it is not already present.
          if [ ! -e f-engrave.py ]; then
            sed 's,#!/usr/bin/python,#!/usr/bin/env python3,' < ${srcFor system}/f-engrave.py | \
              tr -d '\r' > f-engrave.py
            chmod u+wx f-engrave.py
          fi
        '';
      };
    });

    packages = forAllSystems (system: let
      pkgs = pkgsFor system;
    in {
      ttf2xcf_stream = pkgs.callPackage ./ttf2cxf_stream.nix {
        inherit version;
        src = srcFor system;
      };
    });

    checks = forAllSystems (system: let
      pkgs = pkgsFor system;
    in {
      fmt = pkgs.runCommandLocal "alejandra" {} ''
        ${pkgs.alejandra}/bin/alejandra --check ${./.} > "$out";
      '';
    });

    formatter = forAllSystems (system: (pkgsFor system).alejandra);
  };
}
