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
              version = "6.4.0";

              src = pkgs.fetchFromGitHub {
                owner = "paulmcauley";
                repo = pname;
                rev = "6.4.breeze6.4.0";
                sha256 = "sha256-+bYS2Upr84BS0IdA0HlCK0FF05yIMVbRvB8jlN5EOUM=";
              };

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
