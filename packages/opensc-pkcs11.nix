{
  autoPatchelfHook,
  dpkg,
  fetchurl,
  glib,
  openpace,
  openssl,
  stdenvNoCC
}: stdenvNoCC.mkDerivation rec {
  pname = "opensc-pkcs11";
  version = "24.04";

  src = let
    root = "http://security.ubuntu.com/ubuntu/pool/universe/o/opensc";
  in fetchurl {
    url = "${root}/opensc-pkcs11_0.25.0~rc1-1ubuntu0.2_amd64.deb";
    hash = "sha256-+oNam/TFDfxANVV9Ucwzb3c8mtXPZ3cNP+E4WftiHFs=";
  };

  nativeBuildInputs = [ autoPatchelfHook dpkg ];

  buildInputs = [ glib openpace openssl ];

  unpackPhase = ''
    dpkg-deb -x $src .
  '';

  installPhase = ''
    mkdir -p $out/lib
    mv usr/lib/x86_64-linux-gnu/* $out/lib
  '';
}
