# requires: llvmPackages.clang
{ packages ? [], lib, libclang, runCommandLocal }: let
  dev = map (pkg: pkg.dev) packages;
in runCommandLocal "rustenv" {
  buildInputs = [ libclang.lib ] ++ dev;
} ''
  mkdir -p $out/share
  echo "PKG_CONFIG_PATH=$(echo $(
    for p in ${lib.concatStringsSep " " dev}; do
      find $p -name 'pkgconfig' -type d
    done
  ) | tr ' ' ':')" >> $out/share/rustenv.conf
  echo "LIBCLANG_PATH=${libclang.lib}/lib" >> $out/share/rustenv.conf
''
