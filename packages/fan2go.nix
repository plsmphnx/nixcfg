{ fan2go, lib, lm_sensors }: fan2go.overrideAttrs {
  patches = [ ./fan2go/gpd.patch ];
  postInstall = ''
    mkdir -p $out/etc/systemd/system
    cp fan2go.service $out/etc/systemd/system
    substituteInPlace $out/etc/systemd/system/fan2go.service \
      --replace-fail /usr/bin/fan2go $out/bin/fan2go \
      --replace-warn =/etc/sensors =${lib.getLib lm_sensors}/etc/sensors
  '';
}
