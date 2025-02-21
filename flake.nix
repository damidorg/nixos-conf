{
  description = "A very basic flake";

  inputs = {
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    hyprland.url = "github:hyprwm/Hyprland";
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgsStable.url = "github:nixos/nixpkgs?ref=nixos-24.11";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    spicetify-nix.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    grub2-themes = {
      url = "github:vinceliuice/grub2-themes";
    };

  };

  outputs =
    {
      nixpkgs,
      spicetify-nix,
      grub2-themes,
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
