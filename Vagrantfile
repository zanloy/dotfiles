# -*- mode: ruby -*-
# vi: set ft=ruby :

$script = <<SCRIPT
  sudo apt install -y ruby vim zsh
  sudo gem install colorize rake --no-document
SCRIPT

Vagrant.configure("2") do |config|
  config.vm.box = 'ubuntu/bionic64'
  config.vm.synced_folder '.', '/home/vagrant/.dotfiles', disabled: true
  config.vm.provision 'shell', inline: $script

  config.vm.provider "virtualbox" do |vb|
    # This prevents the guest VM from creating a dmesg log file.
    vb.customize [ "modifyvm", :id, "--uartmode1", "disconnected" ]
  end
end
