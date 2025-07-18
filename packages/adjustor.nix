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
  version = "3.10.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hhd-dev";
    repo = "adjustor";
    rev = "refs/tags/v${version}";
    hash = "sha256-4kS4CEEqXZm3n8dPO5Fc+l0e4CfxPMHs64WDXh7lg6o=";
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
