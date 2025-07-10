{ pkgs, user, ... }: {
  environment.systemPackages = with pkgs; [
    git-credential-manager
    tmuxp
    vscode.fhs
    wayvnc
  ];

  virtualisation.podman.dockerCompat = true;
}
