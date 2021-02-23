# qemu_kvm_cgi
This is a web server cgi script and some supporting files for cloning QEMU KVM virtual machines.

This CGI script runs as root on the hypervisor. Ensure sufficient controls are in place in front of this service. 

Identity/authentication etc are not included in this, just the CGI script and required components.

This works with (Apache) web server set to allow CGI script execution, and is run directly on a KVM hypervisor.

A way to use this over a network might include frontends that connect to the hypervisor/s with a VPN.
