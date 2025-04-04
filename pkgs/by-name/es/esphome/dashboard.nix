{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchNpmDeps,

  # build-system
  setuptools,
  nodejs,
  npmHooks,

}:

buildPythonPackage rec {
  pname = "esphome-dashboard";
  version = "20250212.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "esphome";
    repo = "dashboard";
    rev = "refs/tags/${version}";
    hash = "sha256-9yXG9jwB284xTM6L3HWQCRD9Ki1F8yHaEl1vDNDxogw=";
  };

  npmDeps = fetchNpmDeps {
    inherit src;
    hash = "sha256-B0Lx4aH+7NVSMY9qUUOiVeLgIL5wI3JolC9eLzjbRRA=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
  ];

  postPatch = ''
    # https://github.com/esphome/dashboard/pull/639
    patchShebangs script/build
  '';

  preBuild = ''
    script/build
  '';

  # no tests
  doCheck = false;

  pythonImportsCheck = [
    "esphome_dashboard"
  ];

  meta = with lib; {
    description = "ESPHome dashboard";
    homepage = "https://esphome.io/";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ hexa ];
  };
}
