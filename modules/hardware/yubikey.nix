{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ nss.tools opensc yubikey-manager ];
  services.udev.extraRules = ''
    ATTRS{idVendor}=="1050", MODE="0666"
  '';
  systemd.tmpfiles.settings.pcscd."/run/pcscd".d.mode = "0777";
}
