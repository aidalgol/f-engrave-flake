# Nix shell for F-Engrave
The tool [F-Engrave](https://www.scorchworks.com/Fengrave/fengrave.html) is distributed as a single script that is intended to be edited by the end user, so packaging it as an application in [Nixpkgs](https://github.com/NixOS/nixpkgs) would require the end-user to use derivation overrides to customise the script by patching, which is a more tedious workflow than simply editing the file in place.  Hence this flake providing a `devShell` with all of F-Engrave's dependencies, including the bundled helper program `ttf2xcf_stream`.

To use, run `nix develop github:aidalgol/f-engrave-flake`.  This will unpack the `f-engrave.py` script from the F-Engrave source zip archive to the current working directory, if the file does not already exist.
