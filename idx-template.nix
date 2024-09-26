{ pkgs, mode, routing, flutter, backend, ... }: {
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
    jaspr update  
    jaspr create "$out" --mode="${mode}" --routing="${routing}" --flutter="${flutter}" --backend="${backend}"
    mkdir  "$out/.idx/"
    cp ${./dev.nix} "$out/.idx/dev.nix"
    chmod -R +w "$out"
  '';
}