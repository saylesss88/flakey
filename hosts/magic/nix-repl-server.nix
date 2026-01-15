{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  cfg = config.custom.nix-repl-server;

  serverSource = inputs.mdbook-nix-repl + "/server";

  # 1. Build the binary using your package definition
  # serverPkg = pkgs.callPackage ./server-pkg.nix { };
  serverPkg = pkgs.callPackage ./server-pkg.nix {
    src = serverSource;
  };

  # 2. Build a minimal container image containing just the server + nix + deps
  nixReplImage = pkgs.dockerTools.buildLayeredImage {
    name = "nix-repl-server";
    tag = "latest";

    # dependencies needed at runtime inside the container
    contents = [
      serverPkg
      pkgs.nix
      pkgs.bashInteractive
      pkgs.cacert
      pkgs.tini
      pkgs.coreutils
    ];

    config = {
      Entrypoint = [
        "${pkgs.tini}/bin/tini"
        "--"
      ];
      Cmd = [ "${serverPkg}/bin/nix-repl-server" ];
      ExposedPorts = {
        "8080/tcp" = { };
      };
      # Important: Container must see 0.0.0.0 to receive traffic from host port mapping
      Env = [
        "NIX_REPL_BIND=0.0.0.0"
        "NIX_CONFIG=experimental-features = nix-command flakes"
        "SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
      ];
    };
  };
in
{
  options.custom.nix-repl-server = {
    enable = lib.mkEnableOption "nix-repl-server container";
    port = lib.mkOption {
      type = lib.types.port;
      default = 8080;
      description = "Host port to map to the container";
    };
    tokenFile = lib.mkOption {
      type = lib.types.path;
      default = "/etc/nix-repl-server.env";
      description = "Path to file containing NIX_REPL_TOKEN=...";
    };
  };

  config = lib.mkIf cfg.enable {
    # Enable Podman backend
    virtualisation.podman.enable = true;
    virtualisation.oci-containers.backend = "podman";

    # The OCI container definition
    virtualisation.oci-containers.containers.nix-repl-server = {
      image = "nix-repl-server:latest";

      # This effectively "loads" the image into Podman on boot
      imageFile = nixReplImage;

      ports = [ "127.0.0.1:${toString cfg.port}:8080" ];

      # Inject the token safely at runtime (not in Nix store)
      environmentFiles = [ cfg.tokenFile ];

      extraOptions = [
        "--cap-drop=ALL"
        "--security-opt=no-new-privileges"
        "--pull=never" # Use the local loaded image
      ];
    };
  };
}
