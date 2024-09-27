{ pkgs, mode, routing, fltr, backend, ... }:

let
  # Fetch the latest stable Flutter version
  flutter = pkgs.fetchzip {
    url = "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.24.3-stable.tar.xz";  # Update this URL to the latest version
    hash = "sha256-H20ZBUEVBkbWy9DXbJVGyBwdkgaEVoDbgFL2B3UL1Hk=";  # Update the hash when the version changes
  };

  dart-sdk = pkgs.dart;  # Ensure you have the Dart SDK available

in {
  packages = [
    pkgs.curl
    pkgs.gnutar
    pkgs.xz
    pkgs.git
    dart-sdk  # Include the Dart SDK in the environment
  ];

  bootstrap = ''
    # Set up the Flutter environment
    export PATH="$PATH:${flutter}/bin"
    export PATH="$PATH:$HOME/.pub-cache/bin"
    export PATH="$PATH:${dart-sdk}/bin"  # Add Dart SDK to PATH

    # Ensure the Flutter SDK is initialized
    flutter doctor

    # Keep Flutter updated
    flutter channel stable
    flutter upgrade

    # Activate the jaspr CLI
    flutter pub global activate jaspr_cli
    jaspr update

    # Create the project
    jaspr create "$out" --mode="${mode}" --routing="${routing}" --flutter="${fltr}" --backend="${backend}"

    # Set up the output directory
    mkdir -p "$out/.idx/"
    cp ${./dev.nix} "$out/.idx/dev.nix"
    chmod -R +w "$out"
  '';
}
