{
  description = "Zig development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            zig
            sdl3
            sdl3-ttf
          ];

          shellHook = ''
            alias zr='zig build run'
            alias zt='zig build test'
            echo "zr - zig build run"
            echo "zt - zig build test"
          '';
        };
      }
    );
}
