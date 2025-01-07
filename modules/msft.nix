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
    git-credential-manager
    tmuxp
    vscode.fhs
  ];
}
