{
  autoPatchelfHook,
  dpkg,
  electron,
  fetchurl,
  stdenvNoCC
}: stdenvNoCC.mkDerivation rec {
  pname = "minbrowser";
  version = "1.35.5";

  src = let
    root = "https://github.com/minbrowser/min/releases/download";
    arch = {
      x86_64-linux = "amd64";
      aarch64-linux = "arm64";
      armv7l-linux = "armv7l";
    }.${stdenvNoCC.hostPlatform.system};
    hash = {
      amd64 = "sha256-8MIP9ooxPx2MguT1AjuzZzrWXvyEzoJzUOpIFEAIqfk=";
      arm64 = "sha256-As1NUOqSA0Zms+otcMkIF/OzCi9rspd5iOT4NqkOmYU=";
      armv7l = "sha256-N2Rx34UxUKckcaZSdFdNmVhQux6GJQ/Daob+CTlqF/Q=";
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
      --replace-fail /opt $out/opt
  '';
}
