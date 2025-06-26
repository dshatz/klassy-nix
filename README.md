flake.nix inputs

```nix
klassy = {
      url = "github:dshatz/klassy-nix";
      inputs.nixpkgs.follows = "nixpkgs";
};
```

configuration.nix

```nix

environment.systemPackages = [
...
    inputs.klassy.packages.${system}.default
];
```
