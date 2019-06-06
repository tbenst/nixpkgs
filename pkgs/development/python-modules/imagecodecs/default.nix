{ lib, fetchPypi, buildPythonPackage, isPy27
, numpy, enum34, futures, pathlib
, pytest
, cython
, zlib
, lz4
, zstd
, c-blosc
, bzip2
, xz
/* , liblzf # http://oldhome.schmorp.de/marc/liblzf.html */
, libpng
, libwebp
, libjpeg_turbo
/* , charls # https://github.com/team-charls/charls */
, openjpeg_2
, jxrlib
/* , zfp # https://github.com/LLNL/zfp */
, lcms # lcms2
}:

buildPythonPackage rec {
  pname = "imagecodecs";
  version = "2019.5.22";

  src = fetchPypi {
    inherit pname version;
    sha256 = "06bp32h2gsx9wfd1g782dckpprl0l1lfc9hsxngrgp21kda8kmkw";
  };


  /* doCheck = false; */
  /* checkInputs = [ pytest ]; */
  /* checkPhase = '' */
    /* pytest */
  /* ''; */

  nativeBuildInputs = [
    lz4
    zstd
    c-blosc
    bzip2
    xz
    libpng
    libwebp
    libjpeg_turbo
    openjpeg_2
    jxrlib
    lcms # lcms2
  ];

  propagatedBuildInputs = [ numpy ]
    ++ lib.optional isPy27 [ futures enum34 pathlib ];

  meta = with lib; {
    description = "Block-oriented, in-memory buffer transformation, compression, and decompression functions.";
    homepage = https://www.lfd.uci.edu/~gohlke/;
    maintainers = [ maintainers.tbenst ];
    license = licenses.bsd3;
  };
}
