# requires: llvmPackages.clang
{ packages ? [], lib, libclang, runCommandLocal, stdenv }: let
  dev = map (pkg: pkg.dev) packages;
in runCommandLocal "rustenv" {
  buildInputs = [ libclang.lib ] ++ dev;
} ''
  mkdir -p $out/share
  echo "export PKG_CONFIG_PATH=$(
    echo $(for p in ${lib.concatStringsSep " " dev}; do
      find $p -name 'pkgconfig' -type d
    done
  ) | tr ' ' ':')" >> $out/share/rustenv
  echo "export LIBCLANG_PATH=${libclang.lib}/lib" >> $out/share/rustenv
''
