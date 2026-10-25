{ nano-syntax-highlighting }: nano-syntax-highlighting.overrideAttrs {
  fixupPhase = ''
    rm $out/share/zeek.nanorc
  '';
}
