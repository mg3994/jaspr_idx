{ pkgs, mode, routing, fltr, backend, ... }:

let
  # Fetch the latest Flutter stable release
  flutter = pkgs.fetchzip {
    url = "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.24.3-stable.tar.xz";  # Update this URL for the latest version
    hash = "sha256-H20ZBUEVBkbWy9DXbJVGyBwdkgaEVoDbgFL2B3UL1Hk=";  # Update the hash when the version changes
  };

 

in {
  packages = [
    pkgs.curl
    pkgs.gnutar
    pkgs.xz
    pkgs.git
    
  ];

  bootstrap = ''
    cp -rf ${flutter} /home/user/flutter/bin/flutter
    # Set up the Flutter environment
    export PATH="$PATH:${flutter}/bin"
    export PATH="$PATH:$HOME/.pub-cache/bin"
    # Keep Flutter updated
    flutter channel stable
    flutter upgrade

    # Activate the jaspr CLI
    /home/user/flutter/bin/flutter pub global activate jaspr_cli
    jaspr update

    # Create the project
    jaspr create "$out" --mode="${mode}" --routing="${routing}" --flutter="${fltr}" --backend="${backend}"

    # Set up the output directory
    mkdir -p "$out/.idx/"
    cp ${./dev.nix} "$out/.idx/dev.nix"
    chmod -R +w "$out"
  '';
}
