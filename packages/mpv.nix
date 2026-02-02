{ mpv, mpvScripts }: mpv.override {
  scripts = [ mpvScripts.mpris ];
}
