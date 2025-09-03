{
  systemd.services = let
    fans = val: dir: tgt: cfg: let
      path = "/sys/devices/platform/gpd_fan/hwmon/hwmon*/pwm1_enable";
      tgts = map (t: t + ".target") tgt;
    in {
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "/bin/sh -c 'echo ${toString val} | tee ${path}'";
      };
      wantedBy = tgts;
      ${dir} = tgts;
    } // cfg;
  in {
    fan-sleep = fans 2 "before" [ "sleep" "shutdown" ] {};
    fan-awake = fans 1 "after" [ "suspend" "hibernate" ] {
      requisite = [ "handheld-daemon.service" ];
    };
  };
}
