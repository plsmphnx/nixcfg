{ fan2go, fetchFromGitHub, lib, lm_sensors }: fan2go.overrideAttrs {
  version = "0.13.0";
  src = fetchFromGitHub {
    owner = "markusressel";
    repo = "fan2go";
    rev = "0.13.0";
    sha256 = "sha256-9isfgsZxNHjvMkWuhk5m/Z77V7AxJ4pySI+rdWCU7HU=";
  };
  vendorHash = "sha256-6rcU7Qtzz80WcygeLVftdpGYAuzGmWD0M+ZVxgGcgnI=";

  patches = [ ./fan2go/gpd.patch ];
  postInstall = ''
    mkdir -p $out/etc/systemd/system
    cp fan2go.service $out/etc/systemd/system
    substituteInPlace $out/etc/systemd/system/fan2go.service \
      --replace /usr/bin/fan2go $out/bin/fan2go \
      --replace =/etc/sensors =${lib.getLib lm_sensors}/etc/sensors
  '';
}
