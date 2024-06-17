inputs: { config, lib, pkgs, ... }: {
  imports = [
    ../core.nix
    ../laptop.nix
    ../policy.nix
    (import ../ux.nix inputs)
    ../hardware/intel.nix
  ]

  networking.hostName = "clecompt-dev";

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.nftables.enable = lib.mkForce false;
  virtualisation.docker.enable = true;
  users.users.clecompt.extraGroups = [ "docker" ];

  environment.systemPackages = with pkgs; [
    (azure-cli.withExtensions [
      azure-cli.extensions.bastion
    ])
    docker-compose
    dotnet-sdk_8
    gcc
    git-credential-manager
    go_1_21
    graphviz
    k3d
    k9s
    kubectl
    kubernetes-helm
    nodejs_20
    quickemu
    surface-control
    tmuxp
    vscode.fhs
  ];
}
