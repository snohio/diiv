# Testing Notes

I am hopeful that this cookbook serves as a decent example of timing for a moderately simple yet cross OS

## The Charts

| **System Information**                                           |              |               |               |               |                  |               |
| :--------------------------------------------------------------- | -----------: | ------------: | ------------: | ------------: | ---------------: | ------------: |
| Date                                                             |   March 2020 |      May 2020 |      May 2020 |     Sept 2020 |     October 2020 |   August 2021 |
| Computer Model                                                   |    HP 840 G4 | HP zBook x360 | HP zBook x360 | HP zBook x360 | MacBook Pro 2019 | HP zBook x360 |
| OS / Version                                                     |     Win 1803 |      Win 1809 |      Win 1909 |      Win 1909 |    Apple 10.15.5 |      Win 20H2 |
| Client Version:                                                  |      0.16.33 |       0.16.33 |       0.16.33 |      20.8.125 |         20.8.125 |      21.7.524 |
| [speedtest](https://navapps.optum.com/speedtest-master/test.php) |           XX |         35/10 |         34/11 |         45/25 |            82/12 |         37/39 |
| **Command using time in bash**                               | ............ | ............. | ............. | ............. |    ............. | ............. |
| chef -v                                                          |        13.4s |         08.1s |         13.6s |         05.8s |            01.6s |         03.1s |
| cookstyle                                                        |        16.4s |         16.7s |         18.5s |         08.9s |            02.3s |         06.0s |
| chef exec rspec                                                  |     1m 18.8s |         50.0s |      1m 17.6s |         36.6s |            05.1s |         07.9s |
| kitchen create                                                   |     6m 39.4s |      4m 19.1s |      5m 59.6s |      4m 57.2s |         3m 47.8s |      4m 36.5s |
| kitchen converge run 1                                           |    13m 15.6s |     11m 29.7s |      8m 49.4s |      8m 18.7s |         7m 12.0s |      4m 01.0s |
| kitchen converge run 2                                           |      2m 33.3 |      1m 35.4s |      1m 27.5s |      1m 10.8s |            45.1s |         52.4s |
| kitchen verify                                                   |     1m 05.7s |      0m 56.0s |      1m 14.6s |         46.4s |            14.0s |         35.3s |
| kitchen destroy                                                  |     1m 45.9s |      1m 02.4s |      1m 25.9s |         44.9s |           24.12s |         30.5s |
| +=+=+=+=+=+=+=+=+=  TOTAL                                        |    27m 11.5s |     20m 35.4s |     20m 46.7s |     16m 50.5s |        12m 32.0s |     11m 42.5s |
| kitchen test                                                     |              |               |               |     15m 28.3s |                  |     10m 11.4s |

## The Details from zBook x360

Kitchen Create with the images already on my system for two OSes.

```bash
$ kitchen create
-----> Starting Test Kitchen (v2.6.0)
-----> Creating <default-optum-rhel7-standard>...
       Checking for updates to 'optum_rhel7_standard'
       Latest installed version: 1.0.5
       Version constraints: > 1.0.5
       Provider: virtualbox
       Box 'optum_rhel7_standard' (v1.0.5) is running the latest version.
       The following boxes will be kept...
       optum_rhel7_standard   (virtualbox, 1.0.5)
       
       Checking for older boxes...
       No old versions of boxes to remove...
       Bringing machine 'default' up with 'virtualbox' provider...
       ==> default: Importing base box 'optum_rhel7_standard'...
==> default: Matching MAC address for NAT networking...
       ==> default: Checking if box 'optum_rhel7_standard' version '1.0.5' is up to date...
       ==> default: Setting the name of the VM: kitchen-diiv-default-optum-rhel7-standard-ebbf9c15-9d29-40cf-beff-1d4103b10e20
       ==> default: Clearing any previously set network interfaces...
       ==> default: Preparing network interfaces based on configuration...
           default: Adapter 1: nat
       ==> default: You are trying to forward to privileged ports (ports <= 1024). Most
       ==> default: operating systems restrict this to only privileged process (typically
       ==> default: processes running as an administrative user). This is a warning in case
       ==> default: the port forwarding doesn't work. If any problems occur, please try a
       ==> default: port higher than 1024.
       ==> default: Forwarding ports...
           default: 4443 (guest) => 443 (host) (adapter 1)
           default: 4040 (guest) => 4040 (host) (adapter 1)
           default: 22 (guest) => 2222 (host) (adapter 1)
       ==> default: Running 'pre-boot' VM customizations...
       ==> default: Booting VM...
       ==> default: Waiting for machine to boot. This may take a few minutes...
           default: SSH address: 127.0.0.1:2222
           default: SSH username: vagrant
           default: SSH auth method: private key
           default: 
           default: Vagrant insecure key detected. Vagrant will automatically replace
           default: this with a newly generated keypair for better security.
           default: 
           default: Inserting generated public key within guest...
           default: Removing insecure key from the guest if it's present...
           default: Key inserted! Disconnecting and reconnecting using new SSH key...
       ==> default: Machine booted and ready!
       ==> default: Checking for guest additions in VM...
           default: The guest additions on this VM do not match the installed version of
           default: VirtualBox! In most cases this is fine, but in rare cases it can
           default: prevent things such as shared folders from working properly. If you see
           default: shared folder errors, please make sure the guest additions within the
           default: virtual machine match the version of VirtualBox you have installed on
           default: your host and reload your VM.
           default: 
           default: Guest Additions Version: 6.0.22
           default: VirtualBox Version: 6.1
       ==> default: Setting hostname...
       ==> default: Machine not provisioned because `--no-provision` is specified.
       [SSH] Established
       Vagrant instance <default-optum-rhel7-standard> created.
       Finished creating <default-optum-rhel7-standard> (2m2.63s).
-----> Creating <default-optum-win16-standard>...
       Checking for updates to 'optum_win16_standard'
       Latest installed version: 1.0.9
       Version constraints: > 1.0.9
       Provider: virtualbox
       Box 'optum_win16_standard' (v1.0.9) is running the latest version.
       The following boxes will be kept...
       optum_win16_standard   (virtualbox, 1.0.9)
       
       Checking for older boxes...
       No old versions of boxes to remove...
       Bringing machine 'default' up with 'virtualbox' provider...
       ==> default: Importing base box 'optum_win16_standard'...
==> default: Matching MAC address for NAT networking...
       ==> default: Checking if box 'optum_win16_standard' version '1.0.9' is up to date...
       ==> default: Setting the name of the VM: kitchen-diiv-default-optum-win16-standard-282d0f67-ec06-48c9-9740-bcfcc1271e8e
       ==> default: Fixed port collision for 3389 => 3389. Now on port 2200.
       ==> default: Fixed port collision for 4443 => 443. Now on port 2201.
       ==> default: Fixed port collision for 4040 => 4040. Now on port 2202.
       ==> default: Fixed port collision for 22 => 2222. Now on port 2203.
       ==> default: Clearing any previously set network interfaces...
       ==> default: Preparing network interfaces based on configuration...
           default: Adapter 1: nat
       ==> default: Forwarding ports...
           default: 3389 (guest) => 2200 (host) (adapter 1)
           default: 4443 (guest) => 2201 (host) (adapter 1)
           default: 4040 (guest) => 2202 (host) (adapter 1)
           default: 5985 (guest) => 55985 (host) (adapter 1)
           default: 5986 (guest) => 55986 (host) (adapter 1)
           default: 22 (guest) => 2203 (host) (adapter 1)
       ==> default: Running 'pre-boot' VM customizations...
       ==> default: Booting VM...
       ==> default: Waiting for machine to boot. This may take a few minutes...
           default: WinRM address: 127.0.0.1:55985
           default: WinRM username: vagrant
           default: WinRM execution_time_limit: PT2H
           default: WinRM transport: negotiate
       ==> default: Machine booted and ready!
       ==> default: Checking for guest additions in VM...
           default: The guest additions on this VM do not match the installed version of
           default: VirtualBox! In most cases this is fine, but in rare cases it can
           default: prevent things such as shared folders from working properly. If you see
           default: shared folder errors, please make sure the guest additions within the
           default: virtual machine match the version of VirtualBox you have installed on
           default: your host and reload your VM.
           default: 
           default: Guest Additions Version: 6.0.10
           default: VirtualBox Version: 6.1
       ==> default: Machine not provisioned because `--no-provision` is specified.
       [WinRM] Established
       
       Vagrant instance <default-optum-win16-standard> created.
       Finished creating <default-optum-win16-standard> (2m39.52s).
-----> Test Kitchen is finished. (4m53.28s)
```

First time converging. The client is already downloaded but needs to copy to the VM.
Also, the diiv cookbook connects to AWS to grab the 61MB (RHEL) and 132MB (Windows) Subsonic install file.

```$ time kitchen converge
-----> Starting Test Kitchen (v2.6.0)
-----> Converging <default-optum-rhel7-standard>...
       Preparing files for transfer
       Preparing dna.json
       Resolving cookbook dependencies with Berkshelf 7.1.0...
       Removing non-cookbook files before transfer
       Preparing validation.pem
       Preparing client.rb
       el 7 x86_64
       Getting information for chef stable 15.13.8 for el...
       downloading https://omnitruck.chef.io/stable/chef/metadata?v=15.13.8&p=el&pv=7&m=x86_64
         to file /tmp/kitchen/metadata.txt
       trying wget...
       sha1     a01b8674818c59ca8e4d9bb073062fa314dbd547
       sha256   98852814f92791e7da469293561244aeadaf42aa0b55b1128760e11eee6cf2a1
       url      https://packages.chef.io/files/stable/chef/15.13.8/el/7/chef-15.13.8-1.el7.x86_64.rpm
       version  15.13.8
       downloaded metadata file looks valid...
       downloading https://packages.chef.io/files/stable/chef/15.13.8/el/7/chef-15.13.8-1.el7.x86_64.rpm
         to file /tmp/kitchen/chef-15.13.8-1.el7.x86_64.rpm
       trying wget...
       Comparing checksum with sha256sum...
       Installing chef 15.13.8
       installing with rpm...
       warning: /tmp/kitchen/chef-15.13.8-1.el7.x86_64.rpm: Header V4 DSA/SHA1 Signature, key ID 83ef826a: NOKEY
       Preparing...                          ################################# [100%]
       Updating / installing...
          1:chef-15.13.8-1.el7               ################################# [100%]
       Thank you for installing Chef Infra Client! For help getting started visit https://learn.chef.io
       Transferring files to <default-optum-rhel7-standard>
       Starting Chef Infra Client, version 15.13.8
       Creating a new client identity for default-optum-rhel7-standard using the validator key.
       resolving cookbooks for run list: ["diiv::default"]
       Synchronizing Cookbooks:
         - diiv (1.1.0)
       Installing Cookbook Gems:
       Compiling Cookbooks...
       Converging 4 resources
       Recipe: diiv::redhat
         * yum_package[java-1.8.0-openjdk] action install
           - install version 1:1.8.0.242.b08-1.el7.x86_64 of package java-1.8.0-openjdk
         * rpm_package[subsonic] action install
           - install version 6.1.6-0cfa60 of package subsonic
         * service[subsonic] action enable (up to date)
         * service[subsonic] action start (up to date)
         * cookbook_file[/etc/sysconfig/subsonic] action create
           - update content in file /etc/sysconfig/subsonic from 13b388 to 1789cf
           --- /etc/sysconfig/subsonic  2019-11-10 12:30:09.000000000 -0600
           +++ /etc/sysconfig/.chef-subsonic20200918-3702-hk0da0        2020-09-18 06:19:48.048221714 -0500
           @@ -1,26 +1,3 @@
           -#
           -# This is the configuration file for the Subsonic service
           -# (/etc/init.d/subsonic)
           -#
           -# To change the startup parameters of Subsonic, modify
           -# the SUBSONIC_ARGS variable below.
           -#
           -# Type "/usr/share/subsonic/subsonic.sh --help" on the command line to read an
           -# explanation of the different options.
           -#
           -# For example, to specify that Subsonic should use port 80 (for http)
           -# and 443 (for https), and use a Java memory heap size of 200 MB, use
           -# the following:
           -#
           -# SUBSONIC_ARGS="--port=80 --https-port=443 --max-memory=200"
           -
           -SUBSONIC_ARGS="--max-memory=150"
           -
           -
           -# The user which should run the Subsonic process. Default "root".
           -# Note that non-root users are by default not allowed to use ports
           -# below 1024. Also make sure to grant the user write permissions in
           -# the music directories, otherwise changing album art and tags will fail.
           -
           -SUBSONIC_USER=root
           +SUBSONIC_ARGS="--https-port=4443 --max-memory=200"
           +SUBSONIC_USER=vagrant
           - restore selinux security context
         * service[subsonic] action restart
           - restart service service[subsonic]
       
       Running handlers:
       Running handlers complete
       Chef Infra Client finished, 4/6 resources updated in 01 minutes 50 seconds
       Downloading files from <default-optum-rhel7-standard>
       Finished converging <default-optum-rhel7-standard> (2m17.00s).
-----> Converging <default-optum-win16-standard>...
       Preparing files for transfer
       Preparing dna.json
       Resolving cookbook dependencies with Berkshelf 7.1.0...
       Removing non-cookbook files before transfer
       Preparing validation.pem
       Preparing client.rb
       
       ModuleType Version    Name                                ExportedCommands
       ---------- -------    ----                                ----------------
       Script     0.0        Omnitruck                           {Get-ProjectMetadata, Install-Project, install}
       Installing chef from C:\Users\vagrant\AppData\Local\Temp\chef-client-15.13.8-1-x64.msi
       
       
       Transferring files to <default-optum-win16-standard>
       +---------------------------------------------+
       âœ” 2 product licenses accepted.
       +---------------------------------------------+
       Starting Chef Infra Client, version 15.13.8
       Creating a new client identity for default-optum-win16-standard using the validator key.
       resolving cookbooks for run list: ["diiv::default"]
       Synchronizing Cookbooks:
         - diiv (1.1.0)
       Installing Cookbook Gems:
       Compiling Cookbooks...
       Converging 3 resources
       Recipe: diiv::windows
         * directory[C:\temp] action create (up to date)
         * windows_package[Subsonic] action install
         Recipe: <Dynamically Defined Resource>
           * remote_file[C:\Users\vagrant\AppData\Local\Temp\kitchen\cache\package\subsonic-6.1.6-setup.exe] action create
             - create new file C:\temp\subsonic-6.1.6-setup.exe
             - update content in file C:\temp\subsonic-6.1.6-setup.exe from none to 4a997d
             (file sizes exceed 10000000 bytes, diff output suppressed)
           - install version latest of package Subsonic
       Recipe: diiv::windows
         * windows_service[Subsonic] action configure
           - update Subsonic
           -   set service_type to 16 (was 272)
         * windows_service[Subsonic] action start (up to date)
       
       Running handlers:
       Running handlers complete
       Chef Infra Client finished, 3/5 resources updated in 01 minutes 29 seconds
       Downloading files from <default-optum-win16-standard>
       Finished converging <default-optum-win16-standard> (5m44.97s).
-----> Test Kitchen is finished. (8m13.75s)

real    8m18.683s
user    0m0.031s
sys     0m0.061s
```

Running Kitchen Converge again without having to download is considerably quicker.

```sh
$ time kitchen converge
-----> Starting Test Kitchen (v2.6.0)
-----> Converging <default-optum-rhel7-standard>...
       Preparing files for transfer
       Preparing dna.json
       Resolving cookbook dependencies with Berkshelf 7.1.0...
       Removing non-cookbook files before transfer
       Preparing validation.pem
       Preparing client.rb
       chef installation detected
       install_strategy set to 'once'
       Nothing to install
       Transferring files to <default-optum-rhel7-standard>
       Starting Chef Infra Client, version 15.13.8
       resolving cookbooks for run list: ["diiv::default"]
       Synchronizing Cookbooks:
         - diiv (1.1.0)
       Installing Cookbook Gems:
       Compiling Cookbooks...
       Converging 4 resources
       Recipe: diiv::redhat
         * yum_package[java-1.8.0-openjdk] action install (up to date)
         * rpm_package[subsonic] action install (skipped due to not_if)
         * service[subsonic] action enable (up to date)
         * service[subsonic] action start (up to date)
         * cookbook_file[/etc/sysconfig/subsonic] action create (up to date)
       
       Running handlers:
       Running handlers complete
       Chef Infra Client finished, 0/5 resources updated in 04 seconds
       Downloading files from <default-optum-rhel7-standard>
       Finished converging <default-optum-rhel7-standard> (0m14.63s).
-----> Converging <default-optum-win16-standard>...
       Preparing files for transfer
       Preparing dna.json
       Resolving cookbook dependencies with Berkshelf 7.1.0...
       Removing non-cookbook files before transfer
       Preparing validation.pem
       Preparing client.rb
       
       ModuleType Version    Name                                ExportedCommands
       ---------- -------    ----                                ----------------
       Script     0.0        Omnitruck                           {Get-ProjectMetadata, Install-Project, install}
       chef installation detected
       install_strategy set to 'once'
       Nothing to install
       Transferring files to <default-optum-win16-standard>
       Starting Chef Infra Client, version 15.13.8
       resolving cookbooks for run list: ["diiv::default"]
       Synchronizing Cookbooks:
         - diiv (1.1.0)
       Installing Cookbook Gems:
       Compiling Cookbooks...
       Converging 3 resources
       Recipe: diiv::windows
         * directory[C:\temp] action create (up to date)
         * windows_package[Subsonic] action install (skipped due to not_if)
         * windows_service[Subsonic] action configure (up to date)
         * windows_service[Subsonic] action start (up to date)
       
       Running handlers:
       Running handlers complete
       Chef Infra Client finished, 0/4 resources updated in 04 seconds
       Downloading files from <default-optum-win16-standard>
       Finished converging <default-optum-win16-standard> (0m30.86s).
-----> Test Kitchen is finished. (0m56.81s)

real    1m1.709s
user    0m0.015s
sys     0m0.062s
```

Kitchen Verify last.

```sh
$ time kitchen verify
-----> Starting Test Kitchen (v2.6.0)
-----> Setting up <default-optum-rhel7-standard>...
       Finished setting up <default-optum-rhel7-standard> (0m0.00s).
-----> Verifying <default-optum-rhel7-standard>...
       Loaded tests from {:path=>"C:.Users.mbutl11.repos.mbutl11.diiv.test.integration.default"} 

Profile: tests from {:path=>"C:/Users/mbutl11/repos/mbutl11/diiv/test/integration/default"} (tests from {:path=>"C:.Users.mbutl11.repos.mbutl11.diiv.test.integration.default"})
Version: (not specified)
Target:  ssh://vagrant@127.0.0.1:2222

  User vagrant
     [PASS]  is expected to exist
  Port 4443
     [PASS]  is expected to be listening

Test Summary: 2 successful, 0 failures, 0 skipped
       Finished verifying <default-optum-rhel7-standard> (0m15.90s).
-----> Setting up <default-optum-win16-standard>...
       Finished setting up <default-optum-win16-standard> (0m0.00s).
-----> Verifying <default-optum-win16-standard>...
       Loaded tests from {:path=>"C:.Users.mbutl11.repos.mbutl11.diiv.test.integration.default"} 

Profile: tests from {:path=>"C:/Users/mbutl11/repos/mbutl11/diiv/test/integration/default"} (tests from {:path=>"C:.Users.mbutl11.repos.mbutl11.diiv.test.integration.default"})
Version: (not specified)
Target:  winrm://vagrant@http://127.0.0.1:55985/wsman:3389

  User vagrant
     [PASS]  is expected to exist
  Port 4040
     [PASS]  is expected to be listening

Test Summary: 2 successful, 0 failures, 0 skipped
       Finished verifying <default-optum-win16-standard> (0m3.53s).
-----> Test Kitchen is finished. (0m31.42s)

real    0m36.431s
user    0m0.030s
sys     0m0.062s
```

### Chef Spec Times

With two OS listed, here is how long a `chef exec rspec` runs.

```sh
$ time chef.exe exec rspec
..

Finished in 3.55 seconds (files took 26.7 seconds to load)
2 examples, 0 failures


real    0m37.343s
user    0m0.062s
sys     0m0.094s

```

And Cookstyle (which always is running. I'd advise to turn on Auto Save)

```bash
$ time cookstyle
Inspecting 9 files
.........

9 files inspected, no offenses detected

real    0m9.995s
user    0m0.031s
sys     0m0.109s
```

### Chef Version for good measure

```bash
$ time chef.exe -v
Chef Workstation version: 20.8.125
Chef Infra Client version: 16.4.38
Chef InSpec version: 4.22.8
Chef CLI version: 3.0.24
Chef Habitat version: 1.6.56
Test Kitchen version: 2.6.0
Cookstyle version: 6.15.5

real    0m6.718s
user    0m0.078s
sys     0m0.077s
```
