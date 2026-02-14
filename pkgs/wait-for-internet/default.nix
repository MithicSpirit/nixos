{
  lib,
  writeShellScript,
  curl,
  coreutils,
  url ? "http://example.com",
}:
writeShellScript "wait-for-internet" ''
  while ! '${lib.getExe curl}' -fsLm 10 --connect-timeout 2 -o /dev/null '${url}'
  do '${lib.getExe' coreutils "sleep"}' 1
  done
''
