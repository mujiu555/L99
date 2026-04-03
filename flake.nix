{
  description = "Flake for L99 Development";

  inputs = {
    nixpkgs.url = "https://mirrors.ustc.edu.cn/nix-channels/nixos-unstable/nixexprs.tar.xz";
  };

  outputs = { self , nixpkgs ,... }: let
    # system should match the system you are running on
    system = "x86_64-linux";
  in {
    devShells."${system}".default = let
      pkgs = import nixpkgs { inherit system; };
    in pkgs.mkShell {
      packages = with pkgs; [
        (sbcl.withPackages (ps: with ps; [
          quicklisp-starter
          quicklisp-stats
          linedit
          slynk
          slynk-macrostep
          slynk-named-readtables
        ]))
      ];

      shellHook = ''
          export SHELL="/run/current-system/sw/bin/bash" ;
          export shell="/run/current-system/sw/bin/bash" ;
      '';
    };
    packages."${system}".default = let
      pkgs = import nixpkgs { inherit system; };
    in pkgs.runCommand "vm" {
      buildInputs = with pkgs; [
          sbcl
      ];
      nativeBuildInputs = with pkgs; [
        makeWrapper
      ];
    } ''
    '';
  };
}
