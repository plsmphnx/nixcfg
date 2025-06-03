{ pkgs, user, ... }: {
  services.openssh = {
    enable = true;
    startWhenNeeded = true;
    settings = {
      AllowUsers = [ user ];
      PermitRootLogin = "no";
    };
  };

  environment.systemPackages = with pkgs; [
    git-credential-manager
    tmuxp
    vscode.fhs
    wayvnc
  ];

  virtualisation.podman.dockerCompat = true;
}
