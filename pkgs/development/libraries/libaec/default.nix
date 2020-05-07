{ stdenv, fetchzip
, cmake
}:

stdenv.mkDerivation rec {
  pname = "libaec";
  version  = "1.0.4";

  src = fetchzip {
    url = "https://gitlab.dkrz.de/k202009/libaec/-/archive/v${version}/${pname}-v${version}.tar.gz";
    sha256 = "1rpma89i35ahbalaqz82y201syxni7jkf9892jlyyrhhrvlnm4l2";
  };

  buildInputs = [
    cmake
  ];

  meta = with stdenv.lib; {
    homepage = "https://gitlab.dkrz.de/k202009/libaec";
    description = "Adaptive Entropy Coding library";
    license = licenses.bsd2;
    maintainers = with maintainers; [ tbenst ];
  };
}
