{ ... }:
{
  hjemHm.modules = [
    ({ config, lib, ... }: {
      config = {
        assertions = [
          {
            assertion = (config.launchd.agents or { }) == { };
            message = "hjem-hm-modules does not support Home Manager launchd agents.";
          }
          {
            assertion = !(config.programs.home-manager.enable or false);
            message = "hjem-hm-modules does not run Home Manager; programs.home-manager.enable is unsupported.";
          }
        ];

        warnings = lib.optional ((config.home.activation or { }) != { })
          "hjem-hm-modules imports Home Manager modules but does not run Home Manager activation scripts.";
      };
    })
  ];
}
