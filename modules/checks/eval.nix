{ inputs, self, ... }:
{
  perSystem = { pkgs, system, ... }:
  let
    lib = pkgs.lib;

    mkSystem = extraModules: inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        inputs.hjem.nixosModules.default
        self.nixosModules.default
        ({ lib, pkgs, ... }: {
          system.stateVersion = "25.11";
          users.users.alice = {
            isNormalUser = true;
            home = "/home/alice";
          };
          hjem.clobberByDefault = true;
          hjem.users.alice.enable = true;
          hjem.extraModules = [
            ../../tests/fixtures/dummy-a.nix
            ../../tests/fixtures/dummy-b.nix
          ] ++ extraModules;
        })
      ];
    };

    dummySystem = mkSystem [
      ({ lib, ... }: {
        programs.dummy = {
          enable = true;
          message = lib.mkDefault "from-default";
          extraMessage = "from-b";
        };
        home.sessionVariables.DUMMY_FORCE = lib.mkForce "forced";
      })
    ];

    dummy = dummySystem.config.hjem.users.alice;


    badType = builtins.tryEval (builtins.deepSeq (mkSystem [
      ({ ... }: {
        programs.dummy.enable = true;
        programs.dummy.message = 42;
      })
    ]).config.hjem.users.alice.programs.dummy.message true);
  in
  {
    checks.evaluation =
      assert dummy.programs.dummy.message == "from-default";
      assert dummy.xdg.dataFile."dummy/from-b".text == "from-default-from-b";
      assert dummy.home.sessionVariables.DUMMY_ENABLED == "1";
      assert dummy.home.sessionVariables.DUMMY_DEFAULT == "default";
      assert dummy.home.sessionVariables.DUMMY_FORCE == "forced";
      assert builtins.elem pkgs.hello dummy.packages;
      assert dummy.xdg.config.files ? "dummy/config";
      assert dummy.xdg.data.files ? "dummy/from-b";
      assert dummy.systemd.services.dummy.serviceConfig.ExecStart == [ "${pkgs.hello}/bin/hello" ] || dummy.systemd.services.dummy.serviceConfig.ExecStart == "${pkgs.hello}/bin/hello";
      assert dummy.systemd.services.dummy.wantedBy == [ "default.target" ];
      assert badType.success == false;
      pkgs.runCommand "hjem-hm-modules-evaluation" { } "touch $out";

    checks.architecture = pkgs.runCommand "hjem-hm-modules-architecture" { src = ../..; } ''
      set -eu
      if grep -R "lib\.evalModules\|evalModules\|homeManagerConfiguration\|modules/modules\.nix" "$src/modules/+compat" "$src/flake.nix"; then
        echo "forbidden evaluator or Home Manager module graph import in implementation" >&2
        exit 1
      fi
      touch $out
    '';
  };
}
