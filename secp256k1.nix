{ stdenv
, fetchFromGitHub
, autoconf
, automake
, libtool
, secp256k1Src
}:

stdenv.mkDerivation {
  name = "secp256k1";

  src = fetchFromGitHub {
    owner = "bitcoin-core";
    repo = "secp256k1";
    rev = "903b16aa6c354b35ec16489c097a2cde7b2dd330";
    sha256 = "sha256-2G82zHdb2GrNOgGI/22K2rFH8DsAp1i4N+EdFg8xjw4=";
  };

  buildInputs = [ autoconf automake libtool ];

  configurePhase = ''
    ./autogen.sh
    ./configure --enable-module-recovery --enable-module-ecdh --enable-experimental --prefix $lib
  '';

  doCheck = true;
  checkPhase = "./tests";

  outputs = [ "out" "lib" ];
}
