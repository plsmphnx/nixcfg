{
  autoPatchelfHook,
  dpkg,
  electron,
  fetchurl,
  stdenvNoCC
}: stdenvNoCC.mkDerivation rec {
  pname = "minbrowser";
  version = "1.35.6";

  src = let
    root = "https://github.com/minbrowser/min/releases/download";
    arch = {
      x86_64-linux = "amd64";
      aarch64-linux = "arm64";
      armv7l-linux = "armv7l";
    }.${stdenvNoCC.hostPlatform.system};
    hash = {
      amd64 = "sha256-aXnstDzJlvpB3iDr94h0HLFWLD/+21NiD+4wgRZ/JC0=";
      arm64 = "sha256-EJcGXV/pHZRxjcrHy2nU8cl5sVue6C84P8KKhYHUPxA=";
      armv7l = "sha256-s/RvNYN8m1xSxuHuBpm0Ujl1JMwTuUjPubhfusRNNZA=";
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
