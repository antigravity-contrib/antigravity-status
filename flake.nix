{
  description = "agy-status — live Google Antigravity CLI (agy) status line";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        agy-status = pkgs.stdenvNoCC.mkDerivation {
          pname = "agy-status";
          version = pkgs.lib.strings.trim (pkgs.lib.fileContents ./version.txt);
          src = ./.;
          nativeBuildInputs = [ pkgs.makeWrapper ];
          installPhase = ''
            mkdir -p $out/bin $out/share/agy-status
            cp -r queries $out/share/agy-status/
            cp agy-status $out/share/agy-status/
            cp -r themes $out/share/agy-status/
            chmod +x $out/share/agy-status/agy-status
            makeWrapper $out/share/agy-status/agy-status $out/bin/agy-status \
              --prefix PATH : ${
                pkgs.lib.makeBinPath [
                  pkgs.coreutils
                  pkgs.git
                  pkgs.gnugrep
                  pkgs.jq
                ]
              }
          '';
        };
      in
      {
        packages.default = agy-status;

        devShells.default = pkgs.mkShell {
          name = "agy-status";
          packages = with pkgs; [
            bash
            bats
            jq
            shellcheck
          ];
        };
      }
    );
}
