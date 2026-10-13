{ ... }:
{
  hjemHm.modules = [
    ({ config, lib, pkgs, ... }: {
      config = {
        home.homeDirectory = lib.mkDefault config.directory;
        home.stateVersion = lib.mkDefault "25.11";
        home.username = lib.mkDefault config.user;
        systemd.user.systemctlPath = lib.mkDefault "${pkgs.systemd}/bin/systemctl";
      };
    })
  ];
}
