{
    description = "A simple flake for NixOS.";
    
    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    };

    outputs = { nixpkgs, ... } @inputs:
    {
        nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
            modules = [
                ./configuration.nix
                ./hardware-configuration.nix
            ];
        };
    };
}