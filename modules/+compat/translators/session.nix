{ ... }:
{
  hjemHm.modules = [
    ({ config, ... }: {
      config.environment.sessionVariables = config.home.sessionVariables;
    })
  ];
}
