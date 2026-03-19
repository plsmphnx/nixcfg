{ outputs, packages, pkgs, user, ... }: let
  self = packages.${pkgs.stdenv.hostPlatform.system};
in {
  imports = with outputs.nixosModules.library; [ azurevpnclient ];

  environment = {
    pathsToLink = [ "/share/linux-entra-sso" ];
    systemPackages = with pkgs; with self; [
      git-credential-manager
      linux-entra-sso
      lspmux
      vscode.fhs
    ];
  };

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
