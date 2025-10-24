{ config, lib, pkgs, ... }: let
  cfg = config.programs.azurevpnclient;
  azurevpnclient = pkgs.callPackage ../../packages/azurevpnclient.nix {};
in with lib; {
  options.programs.azurevpnclient = {
    enable = mkEnableOption "the Azure VPN Client";

    certs = mkOption {
      type = types.listOf types.str;
      default = [];
      example = [ "DigiCert_Global_Root_CA" ];
      description = "Root certificates to enable.";
    };

    group = mkOption {
      type = types.str;
      default = "networkmanager";
      example = "wheel";
      description = "Group with permissions to utilize resolved.";
    }; 
  };

  config = mkIf cfg.enable {
    security = {
      wrappers.microsoft-azurevpnclient = {
        owner = "root";
        group = "root";
        source = getExe azurevpnclient;
        capabilities = "cap_net_admin+eip";
      };

      polkit.extraConfig = optionalString config.services.resolved.enable ''
        polkit.addRule(function(action, subject) {
          if (
            action.id.indexOf("org.freedesktop.resolve1.") == 0 &&
            subject.isInGroup("${cfg.group}")
          ) { return polkit.Result.YES; }
        });
      '';
    };

    services.resolved.enable = mkDefault true;

    environment = with pkgs; {
      etc = listToAttrs (map (cert: {
        name = "ssl/certs/${cert}.pem";
        value.source = runCommand "${cert}" {} ''
          crt=$(find ${cacert.unbundled}/etc/ssl/certs -name "${cert}:*.crt")
          ${getExe openssl} x509 -in $crt -out $out -outform PEM
        '';
      }) cfg.certs);

      systemPackages = [ zenity ];
    };
  };
}