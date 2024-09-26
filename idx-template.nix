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
    dart pub global activate jaspr_cli  
    jaspr create "$out" --mode="${mode}" --routing="${routing}" --flutter="${flutter}" --backend="${backend}"
    mkdir  "$out/.idx/"
    cp ${./dev.nix} "$out/.idx/dev.nix"
    chmod -R +w "$out"
  '';
}