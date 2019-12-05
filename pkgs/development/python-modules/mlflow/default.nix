{ stdenv, python3Packages, writeText, lib}:

with python3Packages;
python3Packages.buildPythonApplication rec {
  pname = "mlflow";
  version = "1.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9116d82be380c32fa465049d14b217c4c200ad11614f4c6674e6b524b2935206";
  };

  /* patchPhase = ''
    substituteInPlace mlflow/utils/process.py --replace \
      "child = subprocess.Popen(cmd, env=cmd_env, cwd=cwd, universal_newlines=True," \
      "cmd[0]='$out/bin/gunicornMlflow'; child = subprocess.Popen(cmd, env=cmd_env, cwd=cwd, universal_newlines=True,"
  '';

  gunicornScript = writeText "gunicornMlflow"
  ''
      #!/usr/bin/env python
      import re
      import sys
      from gunicorn.app.wsgiapp import run
      if __name__ == '__main__':
        sys.argv[0] = re.sub(r'(-script\.pyw|\.exe)?$', ''', sys.argv[0])
        sys.exit(run())
    '';

    postInstall = ''
      gpath=$out/bin/gunicornMlflow
      cp ${gunicornScript} $gpath
      chmod 555 $gpath
  ''; */


  # run into https://stackoverflow.com/questions/51203641/attributeerror-module-alembic-context-has-no-attribute-config
  # also, tests use conda so can't run on NixOS without buildFHSUserEnv
  doCheck = false;


  propagatedBuildInputs = [
    alembic
    click
    cloudpickle
    requests
    six
    flask
    numpy
    pandas
    python-dateutil
    protobuf
    GitPython
    pyyaml
    querystring_parser
    simplejson
    docker
    databricks-cli
    entrypoints
    sqlparse
    sqlalchemy
    gorilla
    gunicorn
    boto3
    mysqlclient
  ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/mlflow/mlflow";
    description = "Open source platform for the machine learning lifecycle";
    license = licenses.asl20;
    maintainers = with maintainers; [ tbenst ];
  };
}
