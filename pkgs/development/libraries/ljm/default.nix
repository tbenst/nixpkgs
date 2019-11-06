{ stdenv, lib, fetchurl }:

stdenv.mkDerivation rec {
  pname = "ljm";
  version = "2019_07_16";
  alt_version = "20";

  name = "labjack_${pname}_software_${version}_x86_64";
  src = fetchurl {
    url = "https://labjack.com/sites/default/files/software/${name}.tar.gz";
    sha256 = "1nkdimd560400vy5nkkqzgwkd0id15lms0qyasxpv9wss87x2465";
  };

  postUnpack = ''
    echo "=== Extracting makeself archive ==="
    # find offset from file
    runFile=$name/labjack_ljm_installer.run
    offset=$(${stdenv.shell} -c "$(grep -axm1 -e 'offset=.*' $runFile); echo \$offset" $runFile)
    dd if="$runFile" ibs=$offset skip=1 | tar -xzf -
  '';
  patchPhase = ''
    substituteInPlace ../setup.sh \
      --replace "/bin/bash" "${stdenv.shell}" \
      --replace "/usr/local/" "$out/" \
      --replace "PROGRAM_DESTINATION=/opt" "PROGRAM_DESTINATION=$out" \
      --replace "path_exists=$FALSE" "path_exists=$TRUE" \
      --replace "go ldconfig" ""
  '';
  installPhase = ''
    cd ..
    mkdir -p $out/lib
    mkdir $out/share
    mkdir $out/include
    ls
    ./setup.sh "1.20.1"
  '';

  meta = with lib; {
    description = "Read and write Modbus registers implemented on a variety of LabJack devices";
    homepage = "https://labjack.com/support/software/api/ljm";
    /* Should include multiple licenses? https://labjack.com/support/faq/what-labjack-software-licensed-under */
    license = licenses.mit;
    maintainers = with maintainers; [ tbenst ];
    platforms = [ "x86_64-linux" ];
};

}
