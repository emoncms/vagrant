# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

Vagrant.configure(2) do |config|

    config.vm.box = "bento/ubuntu-14.04"
    config.vm.network "forwarded_port", guest: 80, host: 8080

    currentDir = File.dirname(File.expand_path(__FILE__))

    settingsYml = currentDir + "/settings.yml"

    if File.exists? settingsYml then
        settings = YAML::load(File.read(settingsYml))
    else
        puts "Missing settings file. You must have settings.yml in #{currentDir}"
        exit
    end

    if settings.include? 'emoncms'
        config.vm.synced_folder settings["emoncms"], "/var/www/html", :owner => "www-data", :group => "www-data"
    else
        puts "settings missing 'emoncms' from settings.yml"
        exit
    end

    config.vm.provider "virtualbox" do |vb|
        vb.name = "emoncms"
        vb.cpus = 1
        vb.memory = "2048"
    end

    config.vm.provision "shell", path: "./provision/setup.sh", keep_color: true, privileged: false
end
