{ fetchFromGitHub, libpng, libogg, libvorbis, SDL2, stdenv }:
stdenv.mkDerivation rec {
  pname = "megazeux";
  version = "2.93b";
  src = fetchFromGitHub {
    owner = "AliceLR";
    repo = "megazeux";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-hsKV65HUKz1Bo/Yoh3hFlfDbvZ6sWH9jMpONXCs5Y+c=";
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
