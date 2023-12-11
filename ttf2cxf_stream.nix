{
  lib,
  stdenv,
  freetype,
  version,
  src,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "ttf2cxf_stream";
  inherit src version;

  sourceRoot = "${finalAttrs.src.name}/TTF2CXF_STREAM";

  buildInputs = [
    freetype
  ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace '/usr/bin/install' 'install -D' \
      --replace '/usr/local' '${placeholder "out"}'
  '';

  meta = with lib; {
    description = "TTF utility for F-Engrave";
    homepage = "https://www.scorchworks.com/Fengrave/fengrave.html";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [aidalgol];
  };
})
