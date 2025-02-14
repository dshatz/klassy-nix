{
    inputs = {
          nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
          flake-utils.url = "github:numtide/flake-utils";
    };
    outputs = {self, nixpkgs, flake-utils, ...}:

        flake-utils.lib.eachDefaultSystem (system:
          let pkgs = nixpkgs.legacyPackages.${system}; in {

            packages = rec {
              klassy = pkgs.stdenv.mkDerivation rec {
                pname = "klassy";
                version = "6.2.1";

                src = pkgs.fetchFromGitHub {
                  owner = "Foxinatel";
                  repo = pname;
                  rev = "plasma6.2";
                  sha256 = "sha256-9IZhO8a8URTYPv6/bf7r3incfN1o2jBd2+mLVptNRYo=";
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
              default = klassy;
            };
        });
}
