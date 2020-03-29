{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, gfortran, glibcLocales
, numpy, scipy, pytest, pillow
, cython
, joblib
, llvmPackages
}:

buildPythonPackage rec {
  pname = "scikit-learn";
  version = "0.22.1";
  # UnboundLocalError: local variable 'message' referenced before assignment
  disabled = stdenv.isi686;  # https://github.com/scikit-learn/scikit-learn/issues/5534

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256:0z9b44mdiqfnd7nrxw6g2x0gq32pygi70p2li1si0i621wrjbvji";
  };

  buildInputs = [
    pillow
    gfortran
    glibcLocales
  ] ++ lib.optionals stdenv.cc.isClang [
    llvmPackages.openmp
  ];

  nativeBuildInputs = [
    cython
  ];

  propagatedBuildInputs = [
    numpy
    scipy
    numpy.blas
    joblib
  ];
  checkInputs = [ pytest ];

  LC_ALL="en_US.UTF-8";

  doCheck = !stdenv.isAarch64;
  # Skip test_feature_importance_regression - does web fetch
  checkPhase = ''
    cd $TMPDIR
    HOME=$TMPDIR OMP_NUM_THREADS=1 pytest -k "not test_feature_importance_regression" --pyargs sklearn
  '';

  meta = with stdenv.lib; {
    description = "A set of python modules for machine learning and data mining";
    homepage = http://scikit-learn.org;
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
