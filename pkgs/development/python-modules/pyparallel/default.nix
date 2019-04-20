{ pkgs
, lib
, buildPythonPackage
, fetchPypi
, pythonPackages
}:

with pythonPackages;
buildPythonPackage rec {
  pname = "pyparallel";
  version = "0.2.2";

  src = fetchPypi {
    inherit pname version;
    extension = "tar.gz";
    sha256 = "b5550293af42a42d7b2e1ada1224d3c3ce2f09b80e85421820e068655908c611";
  };

  doCheck = false;


  meta = with lib; {
    homepage = "https://github.com/pyserial/pyparallel";
    description = "Python Parallel Port Extension";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ tbenst ];
  };
}
