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
    git config --global --add safe.directory /nix/store/037ykxd947fmv1la96hgsm7m1jrf9mk1-flutter-3.13.8-unwrapped
    flutter upgrade
    dart pub global activate jaspr_cli  
    jaspr update  
    jaspr create "$out" --mode="${mode}" --routing="${routing}" --flutter="${flutter}" --backend="${backend}"
    mkdir  "$out/.idx/"
    cp ${./dev.nix} "$out/.idx/dev.nix"
    chmod -R +w "$out"
  '';
}