{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell rec {
  nativeBuildInputs = with pkgs; [
    libsForQt5.wrapQtAppsHook
    makeWrapper
  ];
  buildInputs = [
    (pkgs.python3.withPackages (ps: with ps; [
      pyqtgraph
    ]))
  ];
  # https://discourse.nixos.org/t/python-qt-woes/11808/10
  shellHook = ''
    setQtEnvironment=$(mktemp --suffix .setQtEnvironment.sh)
    echo "shellHook: setQtEnvironment = $setQtEnvironment"
    makeWrapper "/bin/sh" "$setQtEnvironment" "''${qtWrapperArgs[@]}"
    sed "/^exec/d" -i "$setQtEnvironment"
    source "$setQtEnvironment"
  '';
}