{ lib, pkgs, ... }: {
  networking.nftables.enable = lib.mkForce false;
  virtualisation.docker.enable = true;
  users.users.clecompt.extraGroups = [ "docker" ];

  programs.ssh.startAgent = true;

  environment = {
    sessionVariables.DOTNET_ROOT = "${pkgs.dotnet-sdk_8}";
    systemPackages = with pkgs; [
      cargo
      dapr-cli
      docker-compose
      dotnet-sdk_8
      gcc
      git-credential-manager
      go_1_23
      graphviz
      (k3d.override { k3sVersion = "${kubectl.version}-k3s1"; })
      k9s
      kubectl
      kubernetes-helm
      rustc
      step-cli
      tmuxp
      vscode.fhs
    ];
  };
}
