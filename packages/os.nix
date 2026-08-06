{ dash, lib, writeScriptBin }: writeScriptBin "os" ''
  #!${lib.getExe dash}
  ${lib.readFile ./os/os.sh}
''
