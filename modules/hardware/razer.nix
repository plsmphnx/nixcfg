{ pkgs, ... }: {
  hardware.openrazer = {
    enable = true;
    users = [ "clecompt" ];
  };
  environment.systemPackages = with pkgs; [ polychromatic ];
}
