{ lib, config, pkgs, ... }:
{
  options.programs.dummy = {
    enable = lib.mkEnableOption "dummy program";
    message = lib.mkOption {
      type = lib.types.str;
      default = "hello";
    };
  };

  config = lib.mkIf config.programs.dummy.enable {
    home.packages = [ pkgs.hello ];
    home.sessionVariables.DUMMY_ENABLED = "1";
    xdg.configFile."dummy/config".text = config.programs.dummy.message;
    systemd.user.services.dummy = {
      Unit.Description = "Dummy service";
      Service.ExecStart = "${pkgs.hello}/bin/hello";
      Install.WantedBy = [ "default.target" ];
    };
  };
}
