{ nano-syntax-highlighting }: nano-syntax-highlighting.overrideAttrs {
  postInstall = ''
    rm $out/share/zeek.nanorc
  '';
}
