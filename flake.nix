{
  description = "Flake for L99 Development";

  inputs = {
    nixpkgs.url = "git+https://mirrors.nju.edu.cn/git/nixpkgs.git?ref=nixos-25.11&shallow=1";
  };

  outputs =
    { self, nixpkgs, ... }:
    let
      # system should match the system you are running on
      system = "x86_64-linux";
    in
    {
      devShells."${system}".default =
        let
          pkgs = import nixpkgs { inherit system; };
        in
        pkgs.mkShell {
          packages = with pkgs; [
            (sbcl.withPackages (
              ps: with ps; [
                quicklisp-starter
                quicklisp-stats
                linedit
                slynk
                slynk-macrostep
                slynk-named-readtables
                agnostic-lizard
              ]
            ))
          ];

          shellHook = ''
            export SHELL="/run/current-system/sw/bin/bash" ;
            export shell="/run/current-system/sw/bin/bash" ;
          '';
        };
      packages."${system}".default =
        let
          pkgs = import nixpkgs { inherit system; };
        in
        pkgs.runCommand "vm" {
          buildInputs = with pkgs; [
            sbcl
          ];
          nativeBuildInputs = with pkgs; [
            makeWrapper
          ];
        } "";

    };
}
