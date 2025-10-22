{ config, lib, ... }: let
  cfg = config.systemd.user;
in with lib; {
  options.systemd.user.path = mkOption {
    type = types.nullOr (types.listOf types.str);
    default = null;
    example = [ "/run/wrappers/bin" "/run/current-system/sw/bin" ];
    description = "Default PATH entries for user units.";
  };

  config = mkIf (cfg.path != null) {
    systemd.user.extraConfig = ''
      DefaultEnvironment="PATH=${concatStringsSep ":" cfg.path}"
    '';
  };
}
