{ fetchFromGitHub, libpng, libogg, libvorbis, SDL2, stdenv }:
stdenv.mkDerivation rec {
  pname = "megazeux";
  version = "2.93c";
  src = fetchFromGitHub {
    owner = "AliceLR";
    repo = "megazeux";
    rev = "v${version}";
    sha256 = "sha256-7KNf+pHb7UOnEoK2YiKfHbTxiqtFxWMY8uVhihVRGeU=";
  };
  buildInputs = [ libpng libogg libvorbis SDL2 ];
  preBuild = ''
    ./config.sh \
      --platform unix \
      --prefix $out \
      --sysconfdir $out/etc \
      --gamesdir $out/bin
  '';
}
