{ fetchFromGitHub, libpng, libogg, libvorbis, SDL2, stdenv }:
stdenv.mkDerivation rec {
  pname = "megazeux";
  version = "2.93d";
  src = fetchFromGitHub {
    owner = "AliceLR";
    repo = "megazeux";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-uZvQ4DEXs6B3e7G4cRD+5RJHZaRT8KFGcc26MOmzDG4=";
  };
  buildInputs = [ libpng libogg libvorbis SDL2 ];
  preBuild = ''
    ./config.sh \
      --platform unix \
      --prefix $out \
      --sysconfdir $out/etc \
      --gamesdir $out/bin
  '';
  meta.mainProgram = "megazeux";
}
