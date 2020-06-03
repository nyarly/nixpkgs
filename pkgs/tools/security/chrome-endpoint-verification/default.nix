{ stdenv
, fetchurl
, autoPatchelfHook
, makeWrapper
, dpkg
, gawk
, systemd
, coreutils
, gnugrep
, utillinux
, gnused
, glib
, inetutils
, gnome3 }:
stdenv.mkDerivation rec {
  name = "chrome-endpoint-verification-${version}";
  version = "2019.10.07";

  debName = "endpoint-verification_2019.10.07.c273328186-00_amd64_466d329b82384574a5b062adcd6312623918ac27c5ea3999985856366735bdca.deb";

  src = fetchurl {
    url = "https://packages.cloud.google.com/apt/pool/${debName}";
    sha256 = "1jmx6mkkcmjqk2ckksn54yn1hfb229iwvbb2n2jp8i9qhadk4va6";
    #sha256 = stdenv.lib.fakeSha256;
  };

  nativeBuildInputs = [ autoPatchelfHook dpkg ];

  buildInputs = [
    gawk
    systemd
    coreutils
    gnugrep
    utillinux
    gnused
    glib
    gnome3.dconf
  ];

  sourceRoot = ".";
  unpackCmd = ''dpkg-deb -x "$src" .'';

  patchPhase = ''
    sed -i"" 's#ROOT_DEV=.*#ROOT_DEV=\$(${utillinux}/bin/findmnt -n -o SOURCE /)#' \
      opt/google/endpoint_verification/static_device_state.sh

    substituteInPlace opt/google/endpoint_verification/static_device_state.sh \
      --replace awk ${gawk}/bin/awk \
      --replace udevadm ${systemd}/bin/udevadm \
      --replace cut ${coreutils}/bin/cut \
      --replace grep ${gnugrep}/bin/grep \
      --replace /bin/lsblk ${utillinux}/bin/lsblk \
      --replace sed ${gnused}/bin/sed

    sed -i"" s#\bhostname\b#${inetutils}/bin/hostname# \
      opt/google/endpoint_verification/device_state.sh

    substituteInPlace opt/google/endpoint_verification/device_state.sh \
      --replace awk ${gawk}/bin/awk \
      --replace udevadm ${systemd}/bin/udevadm \
      --replace cut ${coreutils}/bin/cut \
      --replace tr ${coreutils}/bin/tr \
      --replace grep ${gnugrep}/bin/grep \
      --replace /bin/lsblk ${utillinux}/bin/lsblk \
      --replace sed ${gnused}/bin/sed \
      --replace /usr/bin/gsettings ${glib}/bin/gsettings \
      --replace /usr/bin/dconf ${gnome3.dconf}/bin/dconf
  '';

  installPhase = ''
    mkdir -p $out
    cp -a * $out
  '';


  meta = with stdenv.lib; {
    homepage = https://support.google.com/a/users/answer/9018161?hl=en;
    description = "Endpoint verification for G-Suite in Chrome";
    platforms = platforms.linux;
    maintainers = [ maintainers.nyarly ];
  };
}
