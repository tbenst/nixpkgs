{ pkgs
, lib
, buildPythonPackage
, fetchFromGitHub
, pythonPackages
}:

with pythonPackages;
buildPythonPackage rec {
  pname = "psychopy";
  version = "3.0.7";

  src = fetchFromGitHub {
    owner = "psychopy";
    repo = "psychopy";
    rev = "${version}";
    sha256 = "12sl8gr1qwm99s8767gm95ax0ppchg9kd30zhbv9mqrdw056c5h3";
  };

  doCheck = false;

  buildInputs = [
    configobj
    gevent
    greenlet
    GitPython
    lxml
    matplotlib
    msgpack-python
    moviepy
    numpy
    openpyxl
    pandas
    pillow
    pyglet
    pyyaml
    pyopengl
    pyparallel
    requests
    scipy
    sounddevice
    tables
    wxPython
  ];

  meta = with lib; {
    homepage = "https://github.com/psychopy/psychopy";
    description = "For running psychology and neuroscience experiments";
    license = licenses.gpl3;
    maintainers = with maintainers; [ tbenst ];
  };
}
