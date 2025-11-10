{
  description = "OCaml development environment with opam and core";

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
            ocaml
            dune_3
            opam
            ocamlPackages.core
            ocamlPackages.odoc
            ocamlPackages.utop
          ];

          shellHook = ''
            echo "OCaml development environment loaded"
            echo "OCaml version: $(ocaml -version)"
            echo "Opam version: $(opam --version)"
            echo ""
            echo "Available tools:"
            echo "  - ocaml: OCaml compiler"
            echo "  - dune: Build system"
            echo "  - opam: Package manager"
            echo "  - utop: Enhanced REPL"
            echo ""
            echo "To build the project: dune build"
            echo "To run tests: dune test"
          '';
        };
      }
    );
}
