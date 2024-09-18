{ fetchFromGitHub, kernel, stdenv }:
stdenv.mkDerivation rec {
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

  makeFlags = [
    "KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  installPhase = ''
    for file in *.ko; do
      install -D $file $out/lib/modules/${kernel.modDirVersion}/misc/$file
    done
  '';
}
