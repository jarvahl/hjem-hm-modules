{ lib, ... }:
let
  hmFile = lib.types.submodule ({ name, ... }: {
    options = {
      enable = lib.mkOption { type = lib.types.bool; default = true; };
      target = lib.mkOption { type = lib.types.str; default = name; };
      source = lib.mkOption { type = lib.types.nullOr lib.types.path; default = null; };
      text = lib.mkOption { type = lib.types.nullOr lib.types.lines; default = null; };
      executable = lib.mkOption { type = lib.types.bool; default = false; };
      force = lib.mkOption { type = lib.types.bool; default = false; };
    };
  });

  compatOptions = { lib, config, ... }: {
    options = {
      assertions = lib.mkOption { type = lib.types.listOf lib.types.attrs; default = [ ]; };
      warnings = lib.mkOption { type = lib.types.listOf lib.types.str; default = [ ]; };

      home = {
        activation = lib.mkOption { type = lib.types.attrsOf lib.types.anything; default = { }; };
        file = lib.mkOption { type = lib.types.attrsOf hmFile; default = { }; };
        homeDirectory = lib.mkOption { type = lib.types.str; };
        packages = lib.mkOption { type = lib.types.listOf lib.types.package; default = [ ]; };
        sessionVariables = lib.mkOption { type = lib.types.attrsOf lib.types.anything; default = { }; };
        stateVersion = lib.mkOption { type = lib.types.str; };
        username = lib.mkOption { type = lib.types.str; };
      };

      launchd.agents = lib.mkOption { type = lib.types.attrsOf lib.types.anything; default = { }; };
      programs.home-manager.enable = lib.mkOption { type = lib.types.bool; default = false; };

      systemd.user = {
        packages = lib.mkOption { type = lib.types.listOf lib.types.package; default = [ ]; };
        paths = lib.mkOption { type = lib.types.attrsOf lib.types.anything; default = { }; };
        services = lib.mkOption { type = lib.types.attrsOf lib.types.anything; default = { }; };
        sockets = lib.mkOption { type = lib.types.attrsOf lib.types.anything; default = { }; };
        systemctlPath = lib.mkOption { type = lib.types.str; };
        targets = lib.mkOption { type = lib.types.attrsOf lib.types.anything; default = { }; };
        timers = lib.mkOption { type = lib.types.attrsOf lib.types.anything; default = { }; };
      };

      xdg = {
        cacheFile = lib.mkOption { type = lib.types.attrsOf hmFile; default = { }; };
        cacheHome = lib.mkOption { type = lib.types.str; default = "${config.home.homeDirectory}/.cache"; };
        configFile = lib.mkOption { type = lib.types.attrsOf hmFile; default = { }; };
        configHome = lib.mkOption { type = lib.types.str; default = "${config.home.homeDirectory}/.config"; };
        dataFile = lib.mkOption { type = lib.types.attrsOf hmFile; default = { }; };
        dataHome = lib.mkOption { type = lib.types.str; default = "${config.home.homeDirectory}/.local/share"; };
        stateFile = lib.mkOption { type = lib.types.attrsOf hmFile; default = { }; };
        stateHome = lib.mkOption { type = lib.types.str; default = "${config.home.homeDirectory}/.local/state"; };
      };
    };
  };
in
{
  options.hjemHm.modules = lib.mkOption {
    type = lib.types.listOf lib.types.deferredModule;
    default = [ ];
    description = "Hjem user modules collected by the Home Manager compatibility layer.";
  };

  config.hjemHm.modules = [ compatOptions ];
}
