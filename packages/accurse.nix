{ python3Packages }: with python3Packages;
buildPythonApplication rec {
  pname = "accurse";
  version = "0.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ozkNbTrfdCfSk4EY1b4gJSKHlhcSlv2Kb1zTkDq6M0s=";
  };

  build-system = [ hatchling ];
  dependencies = [ lxml ];
}
