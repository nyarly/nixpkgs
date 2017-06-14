{ stdenv, fetchurl, autoconf, automake, libtool }:

stdenv.mkDerivation rec {
  name = "libatomic_ops-${version}";
  version = "7.6.0";

  src = fetchurl {
    url = "http://www.ivmaisoft.com/_bin/atomic_ops/libatomic_ops-${version}.tar.gz";
    sha256 ="03ylfr29g9zc0r6b6axz3i68alj5qmxgzknxwam3jlx0sz8hcb4f";
  };

  nativeBuildInputs = stdenv.lib.optionals stdenv.isCygwin [ autoconf automake libtool ];

  preConfigure = stdenv.lib.optionalString stdenv.isCygwin ''
    sed -i -e "/libatomic_ops_gpl_la_SOURCES/a libatomic_ops_gpl_la_LIBADD = libatomic_ops.la" src/Makefile.am
    ./autogen.sh
  '';

  meta = {
    description = ''A library for semi-portable access to hardware-provided atomic memory update operations'';
    license = stdenv.lib.licenses.gpl2Plus ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.unix;
  };
}
