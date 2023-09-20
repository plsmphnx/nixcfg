{ fetchFromGitHub, libpng, libogg, libvorbis, SDL2, stdenv, ... }:
stdenv.mkDerivation rec {
  pname = "megazeux";
  version = "2.92f";
  src = fetchFromGitHub {
    owner = "AliceLR";
    repo = "megazeux";
    rev = "v${version}";
    sha256 = "sha256-Vir3g5OLsQr49nFZwgZ31Ti37Ub30MtfAnO/0mUUnGY=";
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
