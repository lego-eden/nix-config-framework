            {
  inputs = {
    # This is pointing to an unstable release.
    # If you prefer a stable release instead, you can this to the latest number shown here: https://nixos.org/download
    # i.e. nixos-24.11
    # Use `nix flake update` to update the flake to the latest revision of the chosen release channel.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    iio-hyprland.url = "github:JeanSchoeller/iio-hyprland";
    systems.url = "github:nix-systems/default";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = inputs@{ self, nixpkgs, iio-hyprland, systems, home-manager, ... }:
    let
      eachSystem = nixpkgs.lib.genAttrs (import systems);
      # pkgsBySystem = eachSystem (system: import nixpkgs {
      #   inherit system;
      #   overlays = [ self.overlays.default ];
      # });
    in
  {
    # NOTE: 'nixos' is the default hostname
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit self; };
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.legoeden = ./home.nix;
          }
        ];
      };
    };
    overlays.default = final: prev: {
      scala-latest = prev.callPackage ./packages/scala-latest/scala-latest.nix { };
      iio-hyprland = prev.callPackage iio-hyprland { };
    };
  };
}

