# hjem-hm-modules

Home Manager compatibility layer for Hjem.

## Usage

```nix
{
  imports = [
    inputs.hjem.nixosModules.default
    inputs.hjem-hm-modules.nixosModules.default
  ];
}
```

## Check

```sh
nix flake check
```
