{ pkgs, mode, routing, fltr, backend, ... }:

let
  # Fetch the latest Flutter stable release
  flutter = pkgs.fetchzip {
    url = "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.24.3-stable.tar.xz";  # Update for latest version
    hash = "sha256-H20ZBUEVBkbWy9DXbJVGyBwdkgaEVoDbgFL2B3UL1Hk=";  # Update hash as needed
  };

  dart-sdk = pkgs.dart;  # Include Dart SDK for clarity, but Flutter should have its own
  
in {
  packages = [
    pkgs.curl
    pkgs.gnutar
    pkgs.xz
    pkgs.git
    dart-sdk  # Include Dart SDK in the environment
  ];

  bootstrap = ''
    # Set up the Flutter environment
    export PATH="$PATH:${flutter}/bin"
    export PATH="$PATH:$HOME/.pub-cache/bin"
    export PATH="$PATH:${dart-sdk}/bin"  # Include Dart SDK in PATH

    # Check for Dart SDK existence in Flutter cache
    if [ ! -f "${flutter}/bin/cache/dart-sdk/bin/dart" ]; then
      echo "Dart SDK not found in Flutter cache."
      echo "Running 'flutter doctor' to attempt setup..."
      flutter doctor
    fi

    # Initialize Flutter
    flutter precache  # Ensure Dart SDK and Flutter dependencies are downloaded
    flutter doctor

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
