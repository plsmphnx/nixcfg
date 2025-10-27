{
  autoPatchelfHook,
  atk,
  curl,
  dpkg,
  fetchurl,
  fontconfig,
  glib,
  gtk3,
  libcap,
  libepoxy,
  libsecret,
  openssl,
  pango,
  sqlite,
  stdenv,
  systemd,
  zlib,
}: let
  root = "https://packages.microsoft.com/ubuntu/22.04";
  hash = "sha256-nl02BDPR03TZoQUbspplED6BynTr6qNRVdHw6fyUV3s=";
in stdenv.mkDerivation rec {
  pname = "microsoft-azurevpnclient";
  version = "3.0.0";

  src = fetchurl {
    url = "${root}/prod/pool/main/m/${pname}/${pname}_${version}_amd64.deb";
    inherit hash;
  };

  nativeBuildInputs = [ autoPatchelfHook dpkg ];

  buildInputs = [
    atk
    curl
    fontconfig
    glib
    gtk3
    libcap
    libepoxy
    libsecret
    openssl
    pango
    sqlite
    systemd
    zlib
  ];

  unpackPhase = ''
    dpkg-deb -x $src .
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -r opt $out
    cp -r usr/* $out
    patchelf $out/opt/microsoft/${pname}/${pname} \
      --add-needed $out/opt/microsoft/${pname}/lib/libLinuxCore.so
    ln -s $out/opt/microsoft/${pname}/${pname} $out/bin/${pname}
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace /opt/microsoft/${pname}/${pname} /run/wrappers/bin/${pname} \
      --replace /opt $out/opt \
      --replace /usr/share $out/share
  '';

  meta.mainProgram = pname;
}
