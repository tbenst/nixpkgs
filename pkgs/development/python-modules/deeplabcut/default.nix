{ lib, buildPythonPackage, fetchFromGitHub, fetchzip, fetchurl
, tensorflow
, setuptools_scm
, gzip
, gnutar
, certifi
, chardet
, click
, easydict
, h5py
, imageio
, imgaug
, intel-openmp
, ipython
, matplotlib
, moviepy
, numpy
, opencv3
, pandas
, patsy
, pillow
, pudb
, python
, py
, pyyaml
, requests
, ruamel_yaml
, setuptools
, scikitimage
, scikitlearn
, scipy
, six
, statsmodels
, tables
, tensorpack
, tqdm
, tkinter
, wheel
, wxPython_4_0
, xvfb_run
}:

buildPythonPackage rec {
  pname = "deeplabcut";
  version = "2.1.6";

  # pypi does not contain tests, using github sources instead
  src = fetchFromGitHub {
    owner = "AlexEMG";
    repo = "DeepLabCut";
    rev = "v${version}";
    sha256 = "sha256:0x50qqmyy9iz71w9a3l21sbqh7waddbmzyznmg5bqids2fzhnra8";

  };
  resnet50 = fetchzip {
    url = "http://download.tensorflow.org/models/resnet_v1_50_2016_08_28.tar.gz";
    sha256 = "0n9k24ipgivvvd42h2bn26n4yjab0103ikjwhgcg668vbd5mv587";
  };
  resnet101 = fetchzip {
    url = "http://download.tensorflow.org/models/resnet_v1_101_2016_08_28.tar.gz";
    sha256 = "0h7b963px3xma936zysj54c8l930h3jyss7jv0gzbxalvxzq459x";
  };

  nativeBuildInputs = [
    setuptools_scm 
  ];

  /* buildInputs = with pkgs; [ tk tcl]; */
  propagatedBuildInputs = [
    certifi
    chardet
    click
    easydict
    h5py
    imageio
    imgaug
    intel-openmp
    ipython
    /* ipython-genutils */
    matplotlib
    moviepy
    numpy
    opencv3
    pandas
    patsy
    pillow
    /* python-dateutil */
    pyyaml
    requests
    ruamel_yaml
    setuptools
    scikitimage
    scikitlearn
    scipy
    six
    statsmodels
    tables
    tensorpack
    tensorflow
    tqdm
    tkinter
    wheel
    wxPython_4_0
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "numpy==1.16.4" "numpy" \
      --replace "h5py~=2.7" "h5py" \
      --replace "matplotlib==3.0.3" "matplotlib" \
      --replace "'opencv-python~=3.4'," "" \
      --replace "ruamel.yaml~=0.15" "ruamel.yaml"
  '';
  
  checkInputs = [
    pudb # for debugging...
    py
    xvfb_run
  ];

  checkPhase = ''
    cd examples
    xvfb-run ${python.interpreter} testscript.py
  '';

  defaultLocale = "en_US.UTF-8";

  postInstall = ''
    ln -s $resnet101/* $out/${python.sitePackages}/deeplabcut/pose_estimation_tensorflow/models/pretrained/
    ln -s $resnet50/* $out/${python.sitePackages}/deeplabcut/pose_estimation_tensorflow/models/pretrained/
  '';

  meta = with lib; {
    homepage = "https://github.com/AlexEMG/DeepLabCut";
    maintainers = with maintainers; [ tbenst ];
    description = "Markerless tracking of user-defined features with deep learning";
    license = licenses.lgpl3;
  };
}
