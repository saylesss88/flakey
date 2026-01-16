{
  config,
  lib,
  ...
}:
with lib; {
  options.custom.security.auditd.enable = mkEnableOption "The Linux Audit Daemon";

  config = mkIf config.custom.security.auditd.enable {
    # Enable audit as early as possible during the boot process
    boot.kernelParams = ["audit=1"];
    security.auditd.enable = true;
    security.audit = {
      enable = true;
      rules = [
        # Program Executions
        # Log all program executions on 64-bit architecture
        "-a exit,always -F arch=b64 -S execve"
        # Generate audit record on attempts of "chmod", "fchmod", "fchmodat" syscalls
        "-a always,exit -F arch=b32 -S chmod,fchmod,fchmodat -F auid>=1000 -F auid!=unset -k perm_mod"
        "-a always,exit -F arch=b64 -S chmod,fchmod,fchmodat -F auid>=1000 -F auid!=unset -k perm_mod"
      ];
    };
  };
}
