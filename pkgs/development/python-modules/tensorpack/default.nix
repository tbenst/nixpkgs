{ lib, buildPythonPackage, setuptools_scm, fetchPypi, isPy3k
, numpy
, six
, termcolor
, tabulate
, tqdm
, msgpack
, msgpack-numpy
, pyzmq
, psutil
, scikitimage
, flake8
, tensorflow
}:

buildPythonPackage rec {
  pname = "tensorpack";
  version = "0.9.8";
  disabled=!isPy3k; # Python 2 could be added by motivated contributer

  src = fetchPypi {
    inherit pname version;
    sha256 = "bc6566c12471a0f9c0a79acc3d045595b1943af8e423c5b843986b73bfe5425f";
  };

  nativeBuildInputs = [ setuptools_scm ];

  doCheck=false;
  /* checkInputs = [
    scikitimage
    flake8
    tensorflow
  ]; */
  propagatedBuildInputs = [
    numpy
    six
    termcolor
    tabulate
    tqdm
    msgpack
    msgpack-numpy
    pyzmq
    psutil
  ];

  meta = with lib; {
    homepage = "https://github.com/tensorpack/tensorpack";
    maintainers = with maintainers; [ tbenst ];
    description = "A neural network training interface based on TensorFlow";
    license = licenses.asl20;
  };
}
