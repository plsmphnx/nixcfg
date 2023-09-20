{ fetchgit, qpdf, stdenv, ... }:
stdenv.mkDerivation rec {
  pname = "redact-pdf";
  version = "ab6e4826cfbc61e48db821ada0611ac062733945";
  src = fetchgit {
    url = "https://github.com/plsmphnx/redact-pdf";
    rev = "${version}";
    hash = "sha256-X+K12MlaQYkavjU3bHX5XSZaOQNUaSzva+XUHfJ3q0c=";
  };
  buildInputs = [ qpdf ];
  buildPhase = "./build";
  installPhase = ''
    mkdir -p "$out/bin"
    mv redact-pdf "$out/bin"
  '';
}
