{ lib, pkgs, ... }: {
  networking.nftables.enable = lib.mkForce false;
  virtualisation.docker.enable = true;
  users.users.clecompt.extraGroups = [ "docker" ];

  programs.ssh.startAgent = true;
  services.openssh = {
    enable = true;
    startWhenNeeded = true;
    settings = {
      AllowUsers = [ "clecompt" ];
      PermitRootLogin = "no";
    };
  };

  environment = with pkgs; {
    sessionVariables.DOTNET_ROOT =
      "${dotnetCorePackages.dotnet_8.sdk.src}/share/dotnet";
    systemPackages = [
      cargo
      dapr-cli
      docker-compose
      dotnetCorePackages.dotnet_8.sdk
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
