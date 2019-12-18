{ stdenv
,buildPythonPackage
,fetchurl
,numpy
,scipy
,scikitimage
,opencv3
,six
,imageio
,shapely
,pytest
 }:

buildPythonPackage rec {
  pname = "imgaug";
  version = "0.3.0";

  src = fetchurl {
    url = "https://github.com/aleju/imgaug/archive/c3d99a420efc45652a1264920dc20378a54b1325.zip";
    sha256 = "sha256:174nvhyhdn3vz0i34rqmkn26840j3mnfr55cvv5bdf9l4y9bbjq2";
  };

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "opencv-python-headless" ""
    substituteInPlace setup.py \
      --replace "opencv-python-headless" "" 
    substituteInPlace pytest.ini \
      --replace "--xdoctest --xdoctest-global-exec=\"import imgaug as ia\nfrom imgaug import augmenters as iaa\"" ""
  '';

  propagatedBuildInputs = [
    numpy
    scipy
    scikitimage
    opencv3
    six
    imageio
    shapely
  ];

  checkPhase = ''
     python -m pytest ./test
  '';

  checkInputs = [ opencv3 pytest ];

  meta = with stdenv.lib; {
    homepage = https://github.com/aleju/imgaug;
    description = "Image augmentation for machine learning experiments";
    license = licenses.mit;
    maintainers = with maintainers; [ cmcdragonkai rakesh4g ];
  };
}
