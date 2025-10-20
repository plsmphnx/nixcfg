{ pkgs, user, ... }: {
  hardware.openrazer.enable = true;
  environment.systemPackages = [ pkgs.polychromatic ];
  users.users.${user}.extraGroups = [ "openrazer" ];
}