{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/674f6d128a9ad3bb1fe4e8acc64775ae557b3fc1";

  outputs = { self, nixpkgs }: {
    devShell = nixpkgs.lib.mkDevShell {
      packages = with nixpkgs.pkgs; [
        hugo
      ];
    };
  };
}

