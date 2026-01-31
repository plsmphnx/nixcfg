{ electron-source, lib }: with lib; let
  versions = filter (hasPrefix "electron_") (attrNames electron-source);
  version = n: toIntBase10 (removePrefix "electron_" n);
  latest = v: elemAt (sort (a: b: a > b) v) 0;
in electron-source."electron_${toString (latest (map version versions))}"
