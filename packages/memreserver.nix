{ fetchFromGitLab, libdrm, meson, ninja, pkg-config, stdenv }:
stdenv.mkDerivation rec {
  pname = "memreserver";
  version = "480253e5";
  src = fetchFromGitLab {
    domain = "git.dolansoft.org";
    owner = "lorenz";
    repo = "memreserver";
    rev = "480253e565dab935df1d1c4e615ebc8a8dc81ba4";
    sha256 = "sha256-HjcrH98hH2zKdsHolYCFugL39sT1VjroVhRf8a8dpIA=";
  };
  nativeBuildInputs = [ meson ninja pkg-config ];
  buildInputs = [ libdrm ];
}
