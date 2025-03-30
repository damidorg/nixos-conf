{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgsStable.url = "github:nixos/nixpkgs?ref=nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager";
      # Use the same nixpkgs instance as your system
      inputs.nixpkgs.follows = "nixpkgs";
    };
    grub2-themes = {
      url = "github:vinceliuice/grub2-themes";
    };
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    spicetify-nix.inputs.nixpkgs.follows = "nixpkgs";

  };

  outputs =
    {
      nixpkgs,
      grub2-themes,
      home-manager,
      ...
    }@inputs:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      pkgsStable = inputs.nixpkgsStable.legacyPackages.x86_64-linux;

    in
    {

      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
          grub2-themes.nixosModules.default
          home-manager.nixosModules.default

        ];

      };

      devShells.x86_64-linux.default = pkgs.mkShell {
        buildInputs = [
          pkgs.neovim
          pkgsStable.vim
        ];
      };

    };
}
