{ pkgs, ... }: {
  hardware.openrazer = {
    enable = true;
    users = [ "clecompt" ];
    batteryNotifier.enable = false;
  };
  environment.systemPackages = with pkgs; [ razergenie ];
}
