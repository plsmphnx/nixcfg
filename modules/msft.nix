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

  environment.systemPackages = with pkgs; [
    docker-compose
    git-credential-manager
    (k3d.override { k3sVersion = "${kubectl.version}-k3s1"; })
    k9s
    kubectl
    tmuxp
    vscode.fhs
  ];
}
