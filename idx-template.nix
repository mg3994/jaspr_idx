{ pkgs, mode, routing, flutter, backend, ... }:
let 
  flutter = pkgs.fetchzip {
    url = "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.24.3-stable.tar.xz";
    hash = "sha256-H20ZBUEVBkbWy9DXbJVGyBwdkgaEVoDbgFL2B3UL1Hk=";
  };
  
in {
  packages = [
    pkgs.curl
    pkgs.gnutar
    pkgs.xz
    pkgs.git
    pkgs.busybox
    
  ];
  bootstrap = ''  
    cp -rf ${flutter} flutter
    chmod -R u+w flutter
    export PATH="$PATH":"$HOME/flutter/bin" 
    mkdir -p $HOME/.pub-cache/hosted/pub.dev/
    mkdir -p $HOME/.pub-cache/log
    mkdir -p $HOME/.pub-cache/bin
    export PUB_CACHE=$HOME/.pub-cache
    export PATH="$PATH":"$HOME/.pub-cache/bin"
    ./flutter/bin/dart pub global activate jaspr_cli  
    jaspr update  
    jaspr create "$out" --mode="${mode}" --routing="${routing}" --flutter="${flutter}" --backend="${backend}"
    mkdir  "$out/.idx/"
    cp ${./dev.nix} "$out/.idx/dev.nix"
    chmod -R +w "$out"
  '';
}