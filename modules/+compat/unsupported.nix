{ ... }:
{
  hjemHm.modules = [
    ({ config, lib, ... }: {
      config = {
        assertions = [
          {
            assertion = !(config.programs.home-manager.enable or false);
            message = "hjem-hm-modules does not run Home Manager; programs.home-manager.enable is unsupported.";
          }
        ];
      };
    })
  ];
}
