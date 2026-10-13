{ lib, config, ... }:
{
  options.programs.dummy.extraMessage = lib.mkOption {
    type = lib.types.str;
    default = "extra";
  };

  config = lib.mkIf config.programs.dummy.enable (lib.mkMerge [
    {
      xdg.dataFile."dummy/from-b".text = "${config.programs.dummy.message}-${config.programs.dummy.extraMessage}";
    }
    {
      home.sessionVariables.DUMMY_DEFAULT = lib.mkDefault "default";
      home.sessionVariables.DUMMY_FORCE = lib.mkDefault "weak";
    }
  ]);
}
