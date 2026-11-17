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
      cloud-utils
      libvirt
      qemu_kvm
      swtpm
      virt-manager

      # tunnel
      socat
      xdg-dbus-proxy

      # yubi
      nss.tools
      opensc
      yubikey-manager
    ];
  };

  services.udev.extraRules = ''
    ATTRS{idVendor}=="1050", MODE="0666"
  '';

  systemd.tmpfiles.settings.pcscd."/run/pcscd".d.mode = "0777";

  environment.etc.ovmf.source = "${OVMFFull.fd}/FV";

  virtualisation.podman.dockerCompat = true;
}
