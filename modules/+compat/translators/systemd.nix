{ ... }:
{
  hjemHm.modules = [
    ({ config, lib, ... }:
    let
      mapUnit = unit:
        let
          Unit = unit.Unit or { };
          Install = unit.Install or { };
        in
        {
          description = Unit.Description or null;
          requiredBy = Install.RequiredBy or [ ];
          unitConfig = removeAttrs Unit [ "Description" ];
          wantedBy = Install.WantedBy or [ ];
        }
        // lib.optionalAttrs (unit ? Path) { pathConfig = unit.Path; }
        // lib.optionalAttrs (unit ? Service) { serviceConfig = unit.Service; }
        // lib.optionalAttrs (unit ? Socket) { socketConfig = unit.Socket; }
        // lib.optionalAttrs (unit ? Timer) { timerConfig = unit.Timer; };
    in
    {
      config.systemd = {
        packages = config.systemd.user.packages;
        paths = lib.mapAttrs (_: mapUnit) config.systemd.user.paths;
        services = lib.mapAttrs (_: mapUnit) config.systemd.user.services;
        sockets = lib.mapAttrs (_: mapUnit) config.systemd.user.sockets;
        targets = lib.mapAttrs (_: mapUnit) config.systemd.user.targets;
        timers = lib.mapAttrs (_: mapUnit) config.systemd.user.timers;
      };
    })
  ];
}
