{ outputs, pkgs, ... }: {
  imports = with outputs.nixosModules.library; [ azurevpnclient ];

  environment.systemPackages = with pkgs; [
    git-credential-manager
    lspmux
    quickemu
    vscode.fhs
  ];

  virtualisation.podman.dockerCompat = true;
}
