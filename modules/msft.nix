{ lib, pkgs, ... }: {
  services.openssh = {
    enable = true;
    startWhenNeeded = true;
    settings = {
      AllowUsers = [ "clecompt" ];
      PermitRootLogin = "no";
    };
  };

  environment.systemPackages = with pkgs; [
    git-credential-manager
    tmuxp
    vscode.fhs
    wayvnc
  ];
}
