{ pkgs, mode, routing, fltr, backend, ... }:

let
  # Fetch the latest Flutter stable release
  flutter = pkgs.fetchzip {
    url = "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.24.3-stable.tar.xz";  # Update this URL for the latest version
    hash = "sha256-H20ZBUEVBkbWy9DXbJVGyBwdkgaEVoDbgFL2B3UL1Hk=";  # Update the hash when the version changes
  };

  dart-sdk = pkgs.dart;  # Ensure the Dart SDK is available

in {
  packages = [
    pkgs.curl
    pkgs.gnutar
    pkgs.xz
    pkgs.git
    dart-sdk  # Include the Dart SDK in the environment
  ];

  bootstrap = ''
    cp -rf ${flutter} flutter
    chmod -R u+w flutter
    # Set up the Flutter environment
    export PATH="$PATH:${flutter}/bin"
    export PATH="$PATH:$HOME/.pub-cache/bin"
    export PATH="$PATH:${dart-sdk}/bin"  # Add Dart SDK to PATH

    # Run the Dart SDK update script
    ${flutter}/bin/internal/update_dart_sdk.sh

    # Ensure the Flutter SDK is initialized
    flutter precache  # Precache the Dart SDK and Flutter dependencies
    flutter doctor



    # Check if Dart SDK was updated
    if [ ! -f "${flutter}/bin/cache/dart-sdk/bin/dart" ]; then
      echo "Dart SDK not found after update."
      exit 1
    fi

    # Keep Flutter updated
    flutter channel stable
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
