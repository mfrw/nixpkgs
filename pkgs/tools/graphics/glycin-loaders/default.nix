{ stdenv
, lib
, fetchFromGitLab
, rustPlatform
, cargo
, git
, meson
, ninja
, pkg-config
, rustc
, wrapGAppsHook4
, gtk4
, libheif
, libxml2
, nix-update-script
}:

stdenv.mkDerivation rec {
  pname = "glycin-loaders";
  version = "0.1.beta.2";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "sophie-h";
    repo = "glycin";
    rev = version;
    hash = "sha256-DgTVRWe0iWb7nmD2ZlG36GZx3lp487zZpZatKe3TVwk=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-R74bZ5UVIFJj3pBrLhcGpzjZg8KfIs+tSH6fOBGVujI=";
  };

  nativeBuildInputs = [
    cargo
    git
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    rustc
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    libheif
    libxml2 # for librsvg crate
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Glycin loaders for several formats";
    homepage = "https://gitlab.gnome.org/sophie-h/glycin";
    maintainers = teams.gnome.members;
    license = licenses.lgpl21Only;
    platforms = platforms.linux;
  };
}
