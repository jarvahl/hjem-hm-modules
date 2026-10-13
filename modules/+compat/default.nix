{ config, inputs, ... }:
let
  hjemModule = { pkgs, ... }: {
    _module.args.lib = import (inputs.home-manager + "/modules/lib/stdlib-extended.nix") pkgs.lib;
    imports = config.hjemHm.modules;
  };

  nixosModule = { pkgs, ... }: {
    config = {
      hjem.extraModules = [ hjemModule ];
      hjem.specialArgs.lib = import (inputs.home-manager + "/modules/lib/stdlib-extended.nix") pkgs.lib;
    };
  };
in
{
  flake.nixosModules.default = nixosModule;
}
