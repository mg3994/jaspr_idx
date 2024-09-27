{ pkgs, mode, routing, fltr, backend, ... }:

let 
  flutter = pkgs.fetchFromGitHub {
    owner = "flutter";
    repo = "flutter";
    rev = "refs/heads/stable";  # Get the latest stable branch
    # Specify a tarball format for the fetch
    url = "https://github.com/flutter/flutter/archive/refs/heads/stable.zip";
    # Note: You may want to calculate the hash from the actual downloaded file
    # This is just a placeholder. Update the hash accordingly.
    hash = "sha256-H20ZBUEVBkbWy9DXbJVGyBwdkgaEVoDbgFL2B3UL1Hk="; 
  };

in {
  packages = [
    pkgs.curl
    pkgs.gnutar
    pkgs.xz
    pkgs.git
  ];

  bootstrap = ''
    # Set up the Flutter environment
    export PATH="$PATH:${flutter}/bin"
    export PATH="$PATH:$HOME/.pub-cache/bin"

    # Ensure the Flutter SDK is initialized
    flutter doctor

    # Switch to the master channel if needed
    flutter channel master
    flutter upgrade

    # Activate the jaspr CLI
    dart pub global activate jaspr_cli
    jaspr update

    # Create the project
    jaspr create "$out" --mode="${mode}" --routing="${routing}" --flutter="${fltr}" --backend="${backend}"

    # Set up the output directory
    mkdir -p "$out/.idx/"
    cp ${./dev.nix} "$out/.idx/dev.nix"
    chmod -R +w "$out"
  '';
}
