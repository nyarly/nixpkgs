{ lib, bundlerApp }:

bundlerApp {
  pname = "diecut";
  gemdir = ./.;
  exes = [ "diecut" ];

  meta = with lib; {
    description = "A code generation library designed to allow complex tasks in a straighforward, directed way.";
    homepage    = https://github.com/nyarly/diecut;
    license     = licenses.mit;
    maintainers = [ maintainers.nyarly ];
    platforms   = platforms.unix;
  };
}
