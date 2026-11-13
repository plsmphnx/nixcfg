{ pkgs, user, ... }: {
  environment = with pkgs; {
    share = {
      gitstatus = gitstatus;
      qemu = qemu_kvm;
    };
    systemPackages = [
      git-credential-manager
      lspmux
      vscode.fhs

      libvirt
      spice-gtk
      swtpm
      virt-manager
      
      nss.tools
      opensc
      yubikey-manager
    ];
  };

  programs.dconf.profiles.user.databases = [{
    settings."org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///session" ];
      uris = [ "qemu:///session" ];
    };
  }];

  services.udev.extraRules = ''
    ATTRS{idVendor}=="1050", MODE="0666"
  '';

  systemd.tmpfiles.settings.pcscd."/run/pcscd".d.mode = "0777";

  virtualisation = {
    podman.dockerCompat = true;
    spiceUSBRedirection.enable = true;
  };
}
