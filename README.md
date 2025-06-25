# diiv Cookbook

## About This Cookbook

I run Subsonic at home and always threatened to create a cookbook for it. It turned out easier than I thought. The other thing I wanted to do is have something somewhat functional to test the development laptop. You can review the results of the kitchen runs and other Chef stuff in the [NOTES.md](NOTES.md) file.  All in all it has been about 25 - 40% faster than the standard laptop.

Most recently I switched to Azure for the build. I want to run those times for testing versus VirtualBox. Azure might be my new favorite.

We also switched to a Policyfile model and integrated the `kitchen verify` Inspec tests into a Compliance Profile as a part of the cookbook (client 17)

> UPDATE: This is what iterations are all about. Most of the above statements were true in 2021 when I first wrote this cookbook. 5 years later, some CoPilot (AI) assistance, Azure, github actions and oh so many more changes have moved beyond initial purposes. This has actually become a very good cookbook for learning and sharing with others how you can deploy and manage an application with Chef Infra

---

> NEW NOTE: This cookbook now requires **Chef Client => 18.0**.

## I know this could be better

This was a cookbook to learn how to install and keep running the Subsonic app on my VMs. It sets the RHEL version to port 443 and the windows to http on port 8880.

UPDATE: 1.2.1 - It is actually getting better!

## Missing Pieces - FIXED IT IN 1.2.1

>I was unable to find where the actual configuration for the port was on Windows. There is a Subsonic Control Panel that you can set it to 443 from 4040, but I'm wondering if that is set inside of the database because I can't find a file or registry key for that.

Leaving this here because it is awesome that I found the configuration. This is now in 1.2.1.
We also changed ports from 4040 to 8880 on the http port because that is cached by Cloudflare

## This is done now. Kind of. 3.0.0 To do still

Apparently when configuring the user vagrant to run the service, that account does not have RUN AS SERVICE rights. Only when that is done manually the first time. I'd really like to be able to create a user 'subsonic' and set it as a service. See [Windows_user_privilege](https://docs.chef.io/resource/windows_user_privilege/) and us the privilege 'SeServiceLogonRight'.

> SPECIAL NOTE - This function is not supported until Client 16!

Here's the codeblock for it.

```ruby

user 'subsonic' do
  password "#{randpass}"
end

group 'Administrators' do
  action :modify
  members 'subsonic'
  append true
end

windows_user_privilege 'Log on as a service' do
  privilege   'SeServiceLogonRight'
  users       node['machinename'] + '\subsonic'
  action      :set
end

windows_service 'Subsonic' do
  action [:configure, :start]
  run_as_user '.\vagrant'
  run_as_password 'vagrant'
end
```

Interesting thing here is that when configuring the Log on as a Service right, you need the local machine name (or domain) before the user name. That took some doing but works well. This has only been tested on Windows 2019, but honestly, this application (subsonic) is getting old and stale enough that I'm a bit leary of going further.

We need to do something similar for the Redhat family when selinux is used. It is switched back to Root for now. I would like to create local user accounts with random passwords without local login rights and running the service as them. The MUSIC directory will need to be aligned with that if this cookbook were actually used to configure Subsonic.

## 3.0 Nodes

Apparently 3.0.1 documentation and somehow even the PR was missed. I'm guessing a minor? major? change was made directly to main. Here is the [diff](https://github.com/snohio/diiv/commit/1713c3e1eef0c8875d688f992dec0c43e1eb4081) for that.

- Made Client 18 compatible
- Some account changes. I think I actually deleted some of the documentation around that in the 4.0 release.
- Moved to client 18 selinux resources. This might not work on 17.
- Removed some compliance controls
- Added the Windows subsonic user information

I have no idea why I pushed all of those changes to main, but here we are. And now moving on.

## 4.0 Notes

### Deep Thoughts

Most of these enhancements were done with CoPilot in VSCode. I can't express enough how much it has helped with coding. I still had to do a lot of troubleshooting because what was returned was not the best practice, but it got me started in the right direction and helped solve problems. This is actually a pretty big update despite the [Change Log](CHANGELOG.md) might imply.

- I created my first true custom resource to download some music for examples.
- I fixed the Windows user / password process to be guarded. See below. I removed all of the old info from this readme, so if you want to see those struggles, look at file history.
- Windows Test Kitchen issues / improvements. See the kitchen.yml file (and below)
- A lot of previously used and no longer necessary files have been removed. There was a lot of cleanup.
- As mentioned a CI GitHub Action was applied (this was done directly on `main` in GitHub.dev so this PR would get tested)

### Windows subsonic account and password

> I have a random password creation process working as of 4.0.0. This is now guarded by checking if the account exists before generating the random password and adding it. It looks like this:

```ruby
user_exists = powershell_out!("Get-LocalUser -Name 'subsonic'").exitstatus == 0 rescue false

unless user_exists
  CHARS = ('0'..'9').to_a + ('A'..'Z').to_a + ('a'..'z').to_a + ('!'..')').to_a
  def random_password(length = 18)
    CHARS.sort_by { rand }.join[0...length]
  end
  randpass = random_password
  log "Password is #{randpass}. Forget I every told you that."

  windows_user 'subsonic' do
    password randpass
    action :create
  end
end
```

> BONUS: Honestly, this is the place for a Secrets Management tool and process.

### Windows Kitchen Enhancements

I think I narrowed down some of the ongoing issues with WinRM to Windows systems. The following block in the kitchen.yml file for Windows seems to have improved speed of client install and set WinRM to connect - every time. I do use a kitchen.local.yaml file, but I did copy the changes to `kitchen.yaml` for others to reference. This is more specific to Azure.

```yaml
- name: Windows2019
  os_type: windows
  transport:
    name: winrm
    elevated: true
  driver:
    image_urn: MicrosoftWindowsServer:WindowsServer:2019-Datacenter:latest
    winrm_powershell_script: |-
      Set-MpPreference -DisableRealtimeMonitoring 1
      winrm quickconfig -q
      Set-NetFirewallRule -Name "WINRM-HTTP-In-TCP" -RemoteAddress Any -Enabled True
      Get-NetConnectionProfile | Set-NetConnectionProfile -NetworkCategory Private
```

- The `Set-MpPreference -DisableRealtimeMonitoring 1` line disables Microsoft Defender realtime protection. This seems to improve the install speed of the Chef-client. (I'm running a test right now to see the difference. I will try to remember to report back..) Now, you should turn it back on when you are done. It might even be a good idea to have a Windows cookbook to enable that configuration. :smile:
- The next three lines set the WinRM connects and set the profile of the Network connections. These seemed to have eliminated the need to connect to the server via RDP and pick or ignore network settings.

Provisioning seemed to take almost the same time.. THis is the kitchen create.

```powershell
       IP Address is: 172.190.205.99 [kitchen-bed4a8f63bb49f31.eastus.cloudapp.azure.com]
       Finished creating <default-Windows2019> (2m23.20s).
-----> Converging <default-Windows2019>...
       IP Address is: 172.174.2.181 [kitchen-1a252955167d3832.eastus.cloudapp.azure.com]
       Finished creating <default-Windows2019-def> (2m23.30s).
-----> Converging <default-Windows2019-def>...
       Preparing files for transfer
```

The results are in:

```powershell
 Finished converging <default-Windows2019> (7m0.57s).
 Finished converging <default-Windows2019-def> (9m15.15s).
```

### Figure(d) out why the Windows instance doesn't seem to really work any more

At least in Test Kitchen, I've really been struggling to get the application to actually work right. It seems to take a "reinstall" locally. We're passing the tests because 443 / 8880 are listening, but they just are not returning the web site correctly. I am not sure if this is a Jetty issue inside the application, the way that the file is deployed and restarted or what. Any amounts of tweaking seem to not really help outside of manually installing. So definitely some work to do there. This didn't used to happen... New since 2.0-ish and still happening in 4.0.0.

> OK! Solved, I think. After the installation of the Subsonic service and the first time it starts up, it runs a bunch things that populate the c:\subsonic directory with databases and a bunch of other things. What was happening is that the service was changing the user to subsonic and restarting. That restart broke the completion of building the system. It seemed like the last folder to get created was the lasfmcache2 so I put a ruby block in to wait until all was good. It looks like this:

```ruby
ruby_block 'wait for subsonic install' do
  block do
    require 'timeout'
    Timeout.timeout(240) do # wait up to 4 minutes
      until ::File.exist?('C:/subsonic/lastfmcache2')
        sleep 2
      end
    end
  end
  action :run
  not_if { node['packages']['Subsonic'] }
end
```

### Currently RHEL7 is not 100% working either

- Solved! I removed RHEL7 from the testing platforms.
- I tried adding RHEL9 but the Subsonic installer does not create the service correctly. CoPilot had some suggestions to create a template and the service, but for now, let's stick with just RHEL8 and maybe a variant.

### Lastly - I added some basic CI tests

I copied one of my ci.yaml

### Things left to do in 4.0.x

> I'm kind of done for now. I think it is working un Ubuntu 20, 22, & 24 and RHEL 8 and Windows 2019 and 2022.

- Windows seems to be idempotent. This took some fine tuning and a lot testing.
- Check Client 17 compatibility.
- In code documentation. As this is really a demonstration of what a Chef cookbook can do, it needs more in line documentation.
- Separate kitchen InSpec for verify from Compliance validation. Also based on (new) best practices, you don't need to get deep with the validation but test the functionality.
  - I'd like to test the output of `curl -k https://localhost:443/login.view` to get back `<title>Subsonic</title>`

### What's next for 5.0.0

- The biggest thing I want to accomplish is move all of the recipes for the different OS's to custom resources and only have a default.rb file and potentially see if I can get it to work with a default.yaml file! George Westwater keeps telling me that it is the only way to go and this cookbook might be a good candidate for that.
- Depending on how much longer this will live, potentially get it working on RHEL9 / Rocky 9 / Alma 9.
- I kind of think Windows is done, except for trying it on Windows 2025.
- Client 19 compatibility

### Beyond - Gotta get this working with Habitat

> My plan has always been to use Habitat to build this. I have started to mess with it but keep failing. The move to Temurin JDK 8 might actually be my answer. That, and trying to use CoPilot as it has been a ton of help for the 4.0 release.

## Thanks for Watching

Feel free to give this a clone down and see how it does on your system
