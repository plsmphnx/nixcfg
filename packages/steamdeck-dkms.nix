{ fetchFromGitHub, kernel, stdenv }: let
  modDir = "lib/modules/${kernel.modDirVersion}";
in stdenv.mkDerivation rec {
  pname = "steamdeck-dkms";
  version = "6.8.12-valve2";
  src = fetchFromGitHub {
    owner = "firlin123";
    repo = "steamdeck-dkms";
    rev = "v${version}";
    hash = "sha256-gMzkz60kUNyKtFifY+Lmpjo7uwlz6o0iZlXsX0gtFF8=";
  };
  hardeningDisable = [ "pic" ];
  nativeBuildInputs = kernel.moduleBuildDependencies;
  makeFlags = [ "KERNEL_DIR=${kernel.dev}/${modDir}/build" ];
  installPhase = ''
    for file in *.ko; do
      install -D $file $out/${modDir}/misc/$file
    done
  '';
}
