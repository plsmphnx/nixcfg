{
  fetchFromGitHub,
  glib,
  gobject-introspection,
  kmod,
  lib,
  python3Packages,
  util-linux,
  wrapGAppsHook3
}: python3Packages.buildPythonPackage rec {
  pname = "adjustor";
  version = "3.10.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hhd-dev";
    repo = "adjustor";
    rev = "refs/tags/v${version}";
    hash = "sha256-l9WGtV2MUs7n1xHrk87S6NA+5Nuw3Alam5401ivkRDM=";
  };

  postPatch = ''
    substituteInPlace src/adjustor/core/acpi.py \
      --replace-fail '"modprobe"' '"${lib.getExe' kmod "modprobe"}"'

    substituteInPlace src/adjustor/fuse/utils.py \
      --replace-fail 'f"mount' 'f"${lib.getExe' util-linux "mount"}'
  '';

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    rich
    pyroute2
    fuse
    pygobject3
    dbus-python
    kmod
  ];

  propagatedBuildInputs = [
    wrapGAppsHook3
    glib
    gobject-introspection
  ];

  doCheck = false;
}
