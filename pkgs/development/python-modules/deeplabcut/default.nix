{ lib, pkgs, buildPythonPackage, fetchPypi, python3Packages
, cudaSupport ? false, nvidia_x11 ? null, cudatoolkit ? null, cudnn ? null
, python3
, fetchzip
, tensorflow
, setuptools_scm
, curl
, gzip
, gnutar
, certifi
, chardet
, click
, easydict
, h5py
, imageio
, ipython
, matplotlib
, moviepy
, numpy
, opencv3
, pandas
, patsy
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
, tqdm
, tkinter
, wheel
, wxPython_4_0
}:

assert cudaSupport -> cudatoolkit != null
                   && cudnn != null
                   && nvidia_x11 != null;

let
  my_tf = tensorflow.override {
      cudaSupport = true; nvidia_x11 = nvidia_x11;
      cudatoolkit = cudatoolkit; cudnn = cudnn;
};
  cv_attr = if cudaSupport then { enableFfmpeg = true; enableCuda = true;} else { enableFfmpeg = true; };
  my_opencv = opencv3.override cv_attr;
in
buildPythonPackage rec {
  pname = "deeplabcut";
  version = "2.0.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "19gxd1nij39lbvlpsmx0ibnfcadxbk5n5a3qsyrgv68r6k6i8rk8";
  };

  resnet50 = fetchzip {
    url = "http://download.tensorflow.org/models/resnet_v1_50_2016_08_28.tar.gz";
    sha256 = "0n9k24ipgivvvd42h2bn26n4yjab0103ikjwhgcg668vbd5mv587";
 };
  resnet101 = fetchzip {
    url = "http://download.tensorflow.org/models/resnet_v1_101_2016_08_28.tar.gz";
    sha256 = "0h7b963px3xma936zysj54c8l930h3jyss7jv0gzbxalvxzq459x";
 };

  nativeBuildInputs = [ setuptools_scm curl gzip gnutar];
  /* buildInputs = with pkgs; [ tk tcl]; */
  propagatedBuildInputs = [ setuptools scipy certifi
      chardet
      click
      easydict
      h5py
      imageio
      ipython
      /* ipython-genutils */
      matplotlib
      moviepy
      numpy
      my_opencv
      pandas
      patsy
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
      tqdm
      tkinter
      wheel
      wxPython_4_0
      ]
      ++ lib.optional cudaSupport my_tf;

  postPatch = ''
    sed -i "s/scipy~=1.1.0/scipy/" setup.py
    sed -i "s/ruamel.yaml==0.15/ruamel.yaml/" setup.py
    sed -i "s/imageio==2.3.0/imageio/" setup.py
    sed -i "s/six==1.11.0/six/" setup.py
    sed -i "s/imageio==2.3.0/imageio/" setup.py
    sed -i "s/ipython~=6.0.0/ipython/" setup.py
    sed -i "s/ipython-genutils==0.2.0/ipython-genutils/" setup.py
    sed -i "s/moviepy~=0.2.3.5/moviepy/" setup.py
    sed -i "s/numpy~=1.14.5/numpy/" setup.py
    sed -i "s/'opencv-python~=3.4',//" setup.py
    sed -i "s/'intel-openmp',//" setup.py
    sed -i "s/pandas==0.21.0/pandas/" setup.py
    sed -i "s/python-dateutil==2.7.3/python-dateutil/" setup.py
    sed -i "s/pyyaml>=4.2b1/pyyaml/" setup.py
    sed -i "s/scikit-image~=0.14.0/scikit-image/" setup.py
    sed -i "s/scikit-learn~=0.19.2/scikit-learn/" setup.py
    sed -i "s/scipy~=1.1.0/scipy/" setup.py
    sed -i "s/six==1.11.0/six/" setup.py
    sed -i "s/statsmodels==0.9.0/statsmodels/" setup.py
    sed -i "s/tables==3.4.3/tables/" setup.py
    sed -i "s/wheel==0.31.1/wheel/" setup.py
  '';
  /* checkInputs = with python3Packages; [ */
      /* py */
  /* ]; */
  doCheck = false;


  /* TODO get rid of 3.7 hardcode */
  postInstall = ''
  cp $resnet50/* $out/lib/python3.7/site-packages/deeplabcut/pose_estimation_tensorflow/models/pretrained/
  cp $resnet101/* $out/lib/python3.7/site-packages/deeplabcut/pose_estimation_tensorflow/models/pretrained/
  '';

  meta = with lib; {
    homepage = https://github.com/AlexEMG/DeepLabCut;
    maintainers = with maintainers; [ tbenst ];
    description = "Markerless tracking of user-defined features with deep learning";
    license = licenses.lgpl3;
  };
}
