{
  lib,
  writeShellScript,
  curl,
  coreutils,
  url ? "https://example.com",
}:
writeShellScript "wait-for-internet" ''
  while ! '${lib.getExe curl}' -fsSLm 10 --connect-timeout 2 -o /dev/null '${url}'
  do '${lib.getExe' coreutils "sleep"}' 1
  done
''
