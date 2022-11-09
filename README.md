# diiv Cookbook

## About This Cookbook

I run Subsonic at home and always threatened to create a cookbook for it. It turned out easier than I thought. The other thing I wanted to do is have something somewhat functional to test the development laptop. You can review the results of the kitchen runs and other Chef stuff in the [NOTES.md](NOTES.md) file.  All in all it has been about 25 - 40% faster than the standard laptop.

Most recently I switched to Azure for the build. I want to run those times for testing versus VirtualBox. Azure might be my new favorite.

We also switched to a Policyfile model and integrated the `kitchen verify` Inspec tests into a Compliance Profile as a part of the cookbook (client 17)

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

> I have a random password creation process working as of 3.0.0, however it changes every time the cookbook is run and doesn't update the service and restart it in the case of windows. All the parts and pieces are there however (in the Windows cookbook), I just need to figure out how to create a guard for that. BONUS: Honestly, this is the place for a Secrets Management tool and process.

## Other things added (or partially) more recently and need completed

### Mount the Music folder that is on my s3 storage in Azure

In the files\default path, there are two mnt_music scripts (Powershell and Bash) that can be executed manually for now that will connect the music server to an s3 bucket. This works on Ubuntu, and I am still tweaking RHEL. The Windows one is interesting because in order for you to mount an external device as a drive, you have to be logged in as that user.

### Figure out why the Windows instance doesn't seem to really work any more

At least in Test Kitchen, I've really been struggling to get the application to actually work right. It seems to take a "reinstall" locally. We're passing the tests because 443 / 8880 are listening, but they just are not returning the web site correctly. I am not sure if this is a Jetty issue inside the application, the way that the file is deployed and restarted or what. Any amounts of tweaking seem to not really help outside of manually installing. So definitely some work to do there. This didn't used to happen... New since 2.0-ish.

## Thanks for Watching

Feel free to give this a clone down and see how it does on your system
