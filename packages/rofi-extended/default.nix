{
    stdenv,
    fetchFromGitHub,
    ...
}:

stdenv.mkDerivation {
  name = "rofi-extended";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "adi1090x";
    repo = "rofi";
    rev = "7e236dd67fd98304e1be9e9adc2bed9106cf895b";
    hash = "sha256-K6WQ+olSy6Rorof/EGi9hP2WQpRONjuGREby+aBlzYg=";
  };
  # "sha256": "126dcnhgkwj68j33ndjfji19dzc4pml11zw7mrla9jsji7x9199b",

  # pwd = toString ./. + "";

  buildPhase = ''
    chmod +x setup.sh
  '';


  installPhase = ''
    mkdir -p $out/bin
    mv setup.sh $out/bin/rofi-extended
    mv files $out/bin
    mv fonts $out/bin
  '';
}
