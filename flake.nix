{
    inputs = {
          nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    };
    outputs = {self, nixpkgs, ...}:
        let
            inherit (nixpkgs.lib) genAttrs;

            eachSystem = f: genAttrs
            [
                "aarch64-darwin"
                "aarch64-linux"
                "x86_64-darwin"
                "x86_64-linux"
            ]
            (system: f nixpkgs.legacyPackages.${system});


            klassy-qt6 = {pkgs, ...}: pkgs.stdenv.mkDerivation rec {
              pname = "klassy";
              version = "6.2.1";

              src = pkgs.fetchFromGitHub {
                owner = "paulmcauley";
                repo = pname;
                rev = "6.2.breeze6.2.1";
                sha256 = "sha256-tFqze3xN1XECY74Gj0nScis7DVNOZO4wcfeA7mNZT5M=";
              };

              patches = [
                ./project-version.patch
              ];

              cmakeFlags = ["-DBUILD_TESTING=OFF" "-DBUILD_QT5=OFF"];

              nativeBuildInputs = with pkgs; [cmake kdePackages.extra-cmake-modules];

              buildInputs = with pkgs.kdePackages; [
                wrapQtAppsHook
                kdecoration
                kcoreaddons
                kguiaddons
                kconfigwidgets
                kiconthemes
                kwayland
                kwindowsystem
                kirigami
                frameworkintegration
                kcmutils
                qtsvg
                qtbase
                qtdeclarative
              ] ++ ( with pkgs; [
                hicolor-icon-theme
                xdg-utils
              ]);

              meta = with pkgs.lib; {
                description = "A highly customizable binary Window Decoration and Application Style plugin for recent versions of the KDE Plasma desktop";
                homepage = "https://github.com/paulmcauley/klassy";
                license = with licenses; [gpl2Only gpl2Plus gpl3Only bsd3 mit];
              };
            };
      in {

        packages = eachSystem
                (pkgs: {
                default = klassy-qt6 {
                    inherit pkgs;
                };
                klassy-qt6 = klassy-qt6 { inherit pkgs; };
                });

      };
}
