{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {

  pname = "librewolf-external-editor-revived";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "Frederick888";
    repo = "external-editor-revived";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-K5agRpFJ8iqvPnx3IIMTvrkObT/GB962EtdvWf7Eq4w=";
  };

  cargoHash = "sha256-QYSsdEBNwjpR7lppyOcsc0F8ombBY+dlFRY1GO/D8so=";

  postInstall = ''
    mkdir -p "$out/lib/mozilla/native-messaging-hosts"
    sed -e "s|@PREFIX@|$out|g" '${./native-messaging.json}' >"$out/lib/mozilla/native-messaging-hosts/external_editor_revived.json"
  '';

  meta = with lib; {
    description = "A Thunderbird MailExtension for editing emails in external programs";
    homepage = "https://github.com/Frederick888/external-editor-revived";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ mithicspirit ];
  };

})
