{
  description = "antigravity-status — live Google Antigravity CLI (agy) status line";

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
        antigravity-status = pkgs.stdenvNoCC.mkDerivation {
          pname = "antigravity-status";
          version = pkgs.lib.strings.trim (pkgs.lib.fileContents ./version.txt);
          src = ./.;
          nativeBuildInputs = [ pkgs.makeWrapper ];
          installPhase = ''
            mkdir -p $out/bin $out/share/antigravity-status
            cp -r queries $out/share/antigravity-status/
            cp antigravity-status $out/share/antigravity-status/
            cp -r themes $out/share/antigravity-status/
            chmod +x $out/share/antigravity-status/antigravity-status
            makeWrapper $out/share/antigravity-status/antigravity-status $out/bin/antigravity-status \
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
        packages.default = antigravity-status;

        devShells.default = pkgs.mkShell {
          name = "antigravity-status";
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
