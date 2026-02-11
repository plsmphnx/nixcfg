{ outputs, pkgs, user, ... }: {
  imports = with outputs.nixosModules.library; [ azurevpnclient ];

  environment.systemPackages = with pkgs; [
    git-credential-manager
    lspmux
    vscode.fhs
  ];

  virtualisation = {
    libvirtd = {
      enable = true;
      onBoot = "ignore";
      qemu.swtpm.enable = true;
    };
    podman.dockerCompat = true;
  };

  users.users.${user}.extraGroups = [ "libvirtd" ];

  programs.virt-manager.enable = true;
}
