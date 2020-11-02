{ stdenv
, fetchFromGitHub
, gmp
, secp256k1
, autoconf
, automake
, libtool
, maven
, haskell
, haskellPackages
, perl
, flex
, git
, gcc
, opam
, ocaml
, pandoc
, curl
, rsync
, unzip
, which
, pkgconfig
, zlib
, ncurses
, z3
, mpfr
, openjdk8
, python2
, bash
}:

let haskellPackages' = haskellPackages.override {
      overrides = self: super: {
        stack = haskell.lib.overrideCabal super.stack (attrs: {
          patches = [ ./stack.patch ];
        });
      };
    };
in
stdenv.mkDerivation {
  name = "iele";

  src = fetchFromGitHub {
    owner = "runtimeverification";
    repo = "iele-semantics";
    rev = "5407b1090d78ce02123ad98d0a67b48f902c12d7";
    sha256 = "sha256-r5EomXNuFEu+1dpqtJRzJcdJp7lpvir/ziiSbIoDg6E=";
    fetchSubmodules = true;
  };

  buildInputs = [ autoconf automake libtool secp256k1 maven haskell.compiler.ghc802 haskellPackages'.stack perl flex git gcc opam ocaml pandoc curl rsync unzip which pkgconfig zlib ncurses z3 mpfr gmp openjdk8 python2 bash ];

  patches = [ ./iele-tests.patch ./iele-deps.patch ];

  configurePhase = ''
    export HOME=$NIX_BUILD_TOP
    export LD_LIBRARY_PATH=${gmp.out}/lib:$LD_LIBRARY_PATH
    export NIX_CFLAGS_COMPILE="-Wno-error=unused-result $NIX_CFLAGS_COMPILE"
    make deps
    eval $(opam config env)
  '';

  installPhase = ''
    make install
    mv $HOME/.local $out
  '';
}
