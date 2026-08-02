{ app2unit, fetchFromGitHub }: app2unit.overrideAttrs rec {
  version = "1.4.4";

  src = fetchFromGitHub {
    owner = "Vladimir-csp";
    repo = "app2unit";
    tag = "v${version}";
    sha256 = "sha256-TIY+/9ekGub+10uyqXy5aYU+2NLysMtaQnD1PIjBCFA=";
  };
}
