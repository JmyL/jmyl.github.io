{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/674f6d128a9ad3bb1fe4e8acc64775ae557b3fc1";

  outputs = { self, nixpkgs }:
    let
      systems = nixpkgs.lib.systems.flakeExposed;
    in
    {
      devShells = nixpkgs.lib.genAttrs systems (system:
        let pkgs = import nixpkgs { inherit system; };
        in {
          default = pkgs.mkShell {
            packages = with pkgs; [
              hugo
            ];
          };
        }
      );
    };
}

