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
  postInstall = ''
    install -m 644 -D -t "$out/lib/systemd/system" $src/memreserver.service
    sed -i "s#/usr/local#$out#g" $out/lib/systemd/system/memreserver.service
  '';
}
