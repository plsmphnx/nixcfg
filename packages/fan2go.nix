{ fan2go, fetchFromGitHub }: fan2go.overrideAttrs {
  version = "0.12.0";
  src = fetchFromGitHub {
    owner = "markusressel";
    repo = "fan2go";
    rev = "0.12.0";
    sha256 = "sha256-srBhm1km4Pn3dZWFSxDxD5pH/G0OSzO4iSJU4gW15Ow=";
  };
  vendorHash = "sha256-JOScGakasPLZnWc2jGvG1rw0riuM3PqLCPkn/ja/P3A=";
  patches = [ ./fan2go/gpd.patch ];
}
