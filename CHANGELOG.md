# diiv CHANGELOG

This file is used to list changes made in each version of the diiv cookbook.

## 2.0.0

- Added Ubuntu / Debian to the list of supported platforms
- Moved kitchen test to compliance directory
- Preliminary work on RHEL `firewalld` although had issues with the cookbook. Commented out for now
- Added firewalld check to Inspec Profile

## 1.3.1

- Added SELinux and Firewall to RHEL
- Added SELinux Compliance to the Profile
- Fixed config file (got converted to CRLF)
- Fixed Azure kitchen

## 1.2.1

- Changed the ports to 8880 and 443
- Added the file that configures the Windows port.

## 1.2.0

- Converted to use Policyfiles instead of Berks to play with.
- Added Compliance Profile as a part of Client 17.x

## 1.1.0

- Removed previous companies repositories for Kitchen files
- Updated some wording and few minor tweaks

## 1.0.0

Official release.

- Deployment for Rocky
- Deployment for Windows

This changelog was not kept up to date before 1.2.0
