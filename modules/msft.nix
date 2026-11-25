{ pkgs, user, ... }: with pkgs; {
  environment = {
    share = {
      gitstatus = gitstatus;
      qemu = OVMFFull.fd;
    };
    systemPackages = [
      # dev
      git-credential-manager
      lspmux
      vscode.fhs

      # vm
      libvirt
      qemu_kvm
      socat
      swtpm
      virt-manager
      xorriso

      # sc
      nss.tools
      opensc
    ];
  };

  services.udev.extraRules = ''
    ATTRS{idVendor}=="1050", MODE="0666"
  '';

  systemd.tmpfiles.settings.pcscd."/run/pcscd".d.mode = "0777";

  virtualisation.podman.dockerCompat = true;
}
