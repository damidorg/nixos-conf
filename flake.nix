{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgsStable.url = "github:nixos/nixpkgs?ref=nixos-24.11";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    spicetify-nix.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
     
  };

  outputs = { nixpkgs, spicetify-nix, ... } @ inputs: 
  let
	pkgs = nixpkgs.legacyPackages.x86_64-linux;
	pkgsStable = inputs.nixpkgsStable.legacyPackages.x86_64-linux;
	
  in
  {

    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
	specialArgs= { inherit inputs; };
	modules = [
	  ./configuration.nix
    	];
	};
    
    devShells.x86_64-linux.default = pkgs.mkShell {
	buildInputs = [ pkgs.neovim pkgsStable.vim ];
	};

  };
}
