# diiv Cookbook

## About This Cookbook

I run Subsonic at home and always threatened to create a cookbook for it. It turned out easier than I thought. The other thing I wanted to do is have something somewhat functional to test the development laptop. You can review the results of the kitchen runs and other Chef stuff in the [NOTES.md](NOTES.md) file.  All in all it has been about 25 - 40% faster than the standard laptop.

## I know this could be better

This was a cookbook to learn how to install and keep running the Subsonic app on my VMs. It sets the RHEL version to port 4443 and the windows to http on port 4040.

## Missing Pieces

I was unable to find where the actual configuration for the port was on Windows. There is a Subsonic Control Panel that you can set it to 443 from 4040, but I'm wondering if that is set inside of the database because I can't find a file or registry key for that.

## To do still

Apparently when configuring the user vagrant to run the service, that account does not have RUN AS SERVICE rights. Only when that is done manually the first time. I'd really like to be able to create a user 'subsonic' and set it as a service. See [Windows_user_privilege](https://docs.chef.io/resource/windows_user_privilege/) and us the privilege 'SeServiceLogonRight'.

> SPECIAL NOTE - This funtion is not supported until Client 16!

Here's the codeblock for it.

```ruby
windows_user_privilege 'Log on as a service' do
  privilege   'SeServiceLogonRight'
  users       ['.\vagrant']
  action      :set
end

windows_service 'Subsonic' do
  action [:configure, :start]
  run_as_user '.\vagrant'
  run_as_password 'vagrant'
end
```

I still would like to find how to set the port on Windows. There are other configs I'd like to do but I never really learned the database configurations and commands.

## Thanks for Watching!

Feel free to give this a clone down and see how it does on your system
