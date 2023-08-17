{ lib, buildGoModule, fetchurl, installShellFiles, sqlite }:

buildGoModule rec {
  pname = "honk";
  version = "1.0.0";

  src = fetchurl {
    url = "https://humungus.tedunangst.com/r/honk/d/honk-${version}.tgz";
    hash = "sha256-+0W9HncN+51dRE9bWJU4cAfYOc5bxNAqPe4xY+4UFg0=";
  };
  vendorHash = null;

  buildInputs = [ sqlite ];
  nativeBuildInputs = [ installShellFiles ];
  subPackages = [ "." ];

  postPatch = ''
    substituteInPlace honk.go --replace \
      "var viewDir = \".\"" \
      "var viewDir = \"$out/share/honk\""
  '';

  postInstall = ''
    mkdir -p $out/share/${pname}
    mkdir -p $out/share/doc/${pname}

    mv docs/{,honk-}intro.1
    mv docs/{,honk-}hfcs.1
    mv docs/{,honk-}vim.3
    mv docs/{,honk-}activitypub.7

    installManPage docs/honk.1 docs/honk.3 docs/honk.5 docs/honk.8 \
      docs/honk-intro.1 docs/honk-hfcs.1 docs/honk-vim.3 docs/honk-activitypub.7
    mv docs/{*.html,*.txt,*.jpg,*.png} $out/share/doc/${pname}
    mv views $out/share/${pname}
  '';

  meta = with lib; {
    changelog = "https://humungus.tedunangst.com/r/honk/v/v${version}/f/docs/changelog.txt";
    description = "An ActivityPub server with minimal setup and support costs.";
    homepage = "https://humungus.tedunangst.com/r/honk";
    license = licenses.isc;
    mainProgram = "honk";
    maintainers = with maintainers; [ huyngo ];
  };
}
