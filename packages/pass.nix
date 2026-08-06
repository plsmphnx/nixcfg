{ dash, lib, pass, writeTextFile }: let
  pass-nox = pass.override {
    x11Support = false;
    pass = pass-nox;
  };
in pass-nox.withExtensions (_: [(writeTextFile {
  name = "pass-clip";
  destination = "/lib/password-store/extensions/clip.bash";
  executable = true;
  text = ''
    #!${lib.getExe dash}
    ${lib.readFile ./pass/clip.bash}
  '';
})])
