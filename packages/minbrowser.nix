{
  autoPatchelfHook,
  dpkg,
  electron,
  fetchurl,
  stdenvNoCC
}: stdenvNoCC.mkDerivation rec {
  pname = "minbrowser";
  version = "1.35.8";

  src = let
    root = "https://github.com/minbrowser/min/releases/download";
    arch = {
      x86_64-linux = "amd64";
      aarch64-linux = "arm64";
    }.${stdenvNoCC.hostPlatform.system};
    hash = {
      amd64 = "sha256-Z5G6Xcj9Q0+Gk9kBD6qnH9qzi/Hu9HKCBjneoObQXds=";
      arm64 = "sha256-IbiNbkzIZ8dGdMQKtTYpc9Hb7Y2EyEGa/BG4rNWuGSg=";
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
