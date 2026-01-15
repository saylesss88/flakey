{
  lib,
  rustPlatform,
  nix,
  pkg-config,
  openssl,
  makeWrapper,
  src,
}:

rustPlatform.buildRustPackage {
  pname = "nix-repl-server";
  version = "0.1.0";

  # Point this to your actual source root (where Cargo.toml is)
  # src = ./.;
  inherit src;

  # You must commit Cargo.lock for this to work
  # cargoLock.lockFile = ../../../mdbook-nix-repl/server/Cargo.lock;
  cargoLock.lockFile = "${src}/Cargo.lock";

  postPatch = ''
    cp Cargo.toml.inc Cargo.toml
  '';

  # Runtime dependencies (nix for evaluation)
  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];
  buildInputs = [ openssl ];

  doCheck = false;

  # Ensure 'nix' is available in the path if your binary calls Command::new("nix")
  postInstall = ''
    wrapProgram $out/bin/nix-repl-server --prefix PATH : ${lib.makeBinPath [ nix ]}
  '';

  meta = with lib; {
    description = "Secure Nix REPL server for mdbook-nix-repl";
    platforms = platforms.linux;
  };
}
