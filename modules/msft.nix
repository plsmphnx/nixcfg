{ lib, pkgs, ... }: {
  networking.nftables.enable = lib.mkForce false;
  virtualisation.docker.enable = true;
  users.users.clecompt.extraGroups = [ "docker" ];

  programs.ssh.startAgent = true;

  environment = {
    sessionVariables.DOTNET_ROOT = "${pkgs.dotnet-sdk_8}";
    systemPackages = with pkgs; [
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
      tmuxp
      vscode.fhs
    ];
  };
}
