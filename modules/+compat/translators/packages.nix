{ ... }:
{
  hjemHm.modules = [
    ({ config, ... }: {
      config.packages = config.home.packages;
    })
  ];
}
