{ ... }:
{
  hjemHm.modules = [
    ({ config, lib, pkgs, ... }:
    let
      enabled = lib.filterAttrs (_: file: file.enable);
      fileSource = name: file:
        if (file.source or null) != null then file.source else
        pkgs.writeTextFile {
          name = "home-manager-${lib.replaceStrings [ "/" ] [ "-" ] name}";
          text = file.text or "";
          executable = file.executable or false;
        };
      mapFile = root: prefix: name: file: {
        source = fileSource name file;
        target =
          let
            target = file.target or name;
            rootPrefix = "${root}/";
            prefix' = "${prefix}/";
          in
          if lib.hasPrefix rootPrefix target then lib.removePrefix rootPrefix target
          else if prefix != "" && lib.hasPrefix prefix' target then lib.removePrefix prefix' target
          else target;
        clobber = file.force or false;
      };
      mapFiles = root: prefix: lib.mapAttrs (mapFile root prefix);
    in
    {
      config = {
        files = mapFiles config.home.homeDirectory "" (enabled config.home.file);
        xdg.cache.files = mapFiles config.xdg.cacheHome ".cache" (enabled config.xdg.cacheFile);
        xdg.config.files = mapFiles config.xdg.configHome ".config" (enabled config.xdg.configFile);
        xdg.data.files = mapFiles config.xdg.dataHome ".local/share" (enabled config.xdg.dataFile);
        xdg.state.files = mapFiles config.xdg.stateHome ".local/state" (enabled config.xdg.stateFile);
      };
    })
  ];
}
