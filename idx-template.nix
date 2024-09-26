{ pkgs, template, ... }: {
  packages = [
    pkgs.curl
    pkgs.gnutar
    pkgs.xz
    pkgs.git
    pkgs.busybox
    pkgs.flutter
  ];
  bootstrap = ''  
    export PATH="$PATH":"$HOME/.pub-cache/bin"
    dart pub global activate jaspr_cli  
    jaspr create "$out" --template="${template}"
    mkdir  "$out/.idx/"
    cp ${./dev.nix} "$out/.idx/dev.nix"
    chmod -R +w "$out"
  '';
}