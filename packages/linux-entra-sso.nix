{ dpkg, fetchurl, lib, python3, stdenv }: let
  python = python3.withPackages (pkgs: with pkgs; [ pydbus pygobject3 ]);
in stdenv.mkDerivation rec {
  pname = "linux-entra-sso";
  version = "1.8.0";

  src = let
    root = "https://github.com/siemens/linux-entra-sso/releases/download";
  in fetchurl {
    url = "${root}/v${version}/${pname}_${version}_all.deb";
    hash = "sha256-OR+1Ciy2yt8u/IygNHQnEUUMvf/su1lXH9jZmiHWp2I=";
  };

  nativeBuildInputs = [ dpkg ];

  unpackPhase = ''
    dpkg-deb -x $src .
  '';

  installPhase = ''
    mkdir -p $out/{bin,share/linux-entra-sso/{chromium,firefox}}

    mv usr/libexec/linux-entra-sso/linux-entra-sso.py $out/bin
    substituteInPlace $out/bin/linux-entra-sso.py \
      --replace-fail /usr/bin/python3 ${lib.getExe python}

    mv etc/chromium/native-messaging-hosts \
      $out/share/linux-entra-sso/chromium/NativeMessagingHosts
    mv usr/lib/mozilla/native-messaging-hosts \
      $out/share/linux-entra-sso/firefox/native-messaging-hosts
    substituteInPlace $(find $out/share -name '*.json') \
      --replace-fail /usr/libexec/linux-entra-sso $out/bin
  '';
}
