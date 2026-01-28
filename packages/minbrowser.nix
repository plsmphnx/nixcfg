{
  autoPatchelfHook,
  dpkg,
  electron,
  fetchurl,
  stdenvNoCC
}: stdenvNoCC.mkDerivation rec {
  pname = "minbrowser";
  version = "1.35.3";

  src = let
    root = "https://github.com/minbrowser/min/releases/download";
    arch = {
      x86_64-linux = "amd64";
      aarch64-linux = "arm64";
      armv7l-linux = "armv7l";
    }.${stdenvNoCC.hostPlatform.system};
    hash = {
      amd64 = "sha256-2WR/rjJD66ue5GuE/sl1G8z6EG9YLhphJoVeepXwwH8=";
      arm64 = "sha256-Z4oUy7k+abCwTdhPscREEc9S/gi4tYR7PlidODgPlqY=";
      armv7l = "sha256-koUBdFPR322lfStjLwGU8yx1+1nKPvPmfGLkK+AVRi4=";
    };
  in fetchurl {
    url = "${root}/v${version}/min-${version}-${arch}.deb";
    hash = hash.${arch};
  };

  nativeBuildInputs = [ autoPatchelfHook dpkg ];

  inherit (electron.unwrapped) buildInputs;

  unpackPhase = ''
    dpkg-deb -x $src .
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv opt usr/* $out
    ln -s $out/opt/Min/min $out/bin/min
    substituteInPlace $out/share/applications/min.desktop \
      --replace /opt $out/opt
  '';
}
