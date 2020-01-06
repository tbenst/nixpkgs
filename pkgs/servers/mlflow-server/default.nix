{lib, python3Packages, writeText}:

python3Packages.toPythonApplication 
  (python3Packages.mlflow.overrideAttrs(old: rec {
    pname = "mlflow-server";

    propagatedBuildInputs = old.propagatedBuildInputs ++ [
      python3Packages.boto3
      python3Packages.mysqlclient
    ];

    patchPhase = ''
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
    '';
}))