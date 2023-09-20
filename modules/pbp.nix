{ config, pkgs, ... }: {
  networking.hostName = "clecompt-pine";
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    efiInstallAsRemovable = true;
    configurationLimit = 4;
  };
  boot.consoleLogLevel = 2;

  boot.kernelModules = [ "rkvdec" ];

  nixpkgs.overlays = [(self: super: {
    lite-xl = super.lite-xl.overrideAttrs (prev: {
      version = "git";
      src = pkgs.fetchFromGitHub {
        owner = "jgmdev";
        repo = "lite-xl";
        rev = "06bc3f14017a9d53eec0c50912d5923c59d8dc68";
        sha256 = "sha256-WikS0MpY0cwZGCLAVTj7UeR8orOfWirTTEn0hkEc/UY=";
      };
    });
  })];
}
