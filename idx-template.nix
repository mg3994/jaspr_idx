{ pkgs, mode, routing, fltr, backend, ... }:

let
  # Function to fetch the latest Flutter hash dynamically
  fetchFlutterHash = builtins.fetchGit {
    url = "https://github.com/flutter/flutter.git";
    rev = "refs/heads/stable";
  };

  flutter = pkgs.fetchFromGitHub {
    owner = "flutter";
    repo = "flutter";
    rev = fetchFlutterHash.rev;  # Use the latest stable branch
    url = "https://github.com/flutter/flutter/archive/refs/heads/stable.zip";
    hash = builtins.hashFile "sha256" "${fetchFlutterHash}/stable.zip";  # Calculate hash dynamically
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
