{ config, lib, ... }: let
  cfg = config.systemd.user;
in with lib; {
  options.systemd.user.path = mkOption {
    type = types.listOf types.str;
    default = [];
    example = [ "/run/wrappers/bin" "/run/current-system/sw/bin" ];
    description = "Default PATH entries for user units.";
  };

  config = mkIf (cfg.path != []) {
    systemd.user.extraConfig = ''
      DefaultEnvironment="PATH=${concatStringsSep ":" cfg.path}"
    '';
  };
}
