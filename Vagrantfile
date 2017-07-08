# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-16.04"

  config.vm.box_check_update = false

  config.vm.provider "virtualbox" do |vb|
      vb.name = "dev-vm-rails5-base"
      vb.memory = "2560"
      vb.cpus = 1
      vb.customize ['modifyvm', :id, '--vram', '16']
      vb.customize [ "guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 5000 ]
  end

  config.vm.synced_folder "../", "/home/vagrant/repos"

  config.ssh.forward_agent = true
  config.ssh.insert_key = false

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  config.vm.provision "shell", inline: <<-SHELL
    # update packages
    apt-get update -y

    # upgrade packages asap
    apt-get upgrade -y

    # install DKMS for virtual box
    apt-get install -y virtualbox-dkms

    # shell and rbenv dependencies
    apt-get install -y build-essential zsh zsh-syntax-highlighting

    # ruby dependencies
    apt-get install -y libssl-dev libreadline-dev zlib1g-dev

    # sqllite, nodejs and yaml libraries
    apt-get install -y libyaml-dev libsqlite3-dev sqlite3

    # install v6 of node.js
    curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
    apt-get install -y nodejs

    # install yarn to enable webpack
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

    apt-get update && apt-get install -y yarn

    # postgres & redis
    apt-get install -y postgresql-9.5 postgresql-common libpq-dev redis-server

    # config postgres for md5 login locally
    sed -i -E 's/(local.+all.+all.+)peer/\\1md5/g' /etc/postgresql/9.5/main/pg_hba.conf

    # conf postgres to be accessible by host system
    sed -i -E 's/(host.+all.+all.+)127.0.0.1/32/\\1  0.0.0.0/0 /g' /etc/postgresql/9.5/main/pg_hba.conf
    sed -i "59ilisten_addresses = '*'" /etc/postgresql/9.5/main/postgresql.conf

    # add current heroku tools
    sudo apt-get install software-properties-common
    sudo add-apt-repository "deb https://cli-assets.heroku.com/branches/stable/apt ./"
    curl -L https://cli-assets.heroku.com/apt/release.key | sudo apt-key add -
    sudo apt-get update
    sudo apt-get install heroku
  SHELL

  config.vm.provision "shell", privileged: false, inline: <<-SCRIPT
    # configure ZSH and make default prompt
    cp /vagrant/setup/.zshrc ~/.
    mkdir ~/.bin
    curl -sL https://github.com/djl/vcprompt/raw/master/bin/vcprompt > ~/.bin/vcprompt
    chmod 755 ~/.bin/vcprompt
    ln -s /usr/bin/python3 $HOME/.bin/python

    # configure rbenv and install ruby versions
    git clone https://github.com/rbenv/rbenv.git ~/.rbenv
    git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
    cd ~/.rbenv && src/configure && make -C src && cd ~

    export PATH=$HOME/.rbenv/bin:$PATH

    eval "$(rbenv init -)"

    rbenv install 2.3.4
    rbenv install 2.4.1
    rbenv global 2.4.1

    rbenv rehash

    # install bundler
    gem install bundler

    git clone https://github.com/ac21/vimfiles.git ~/.vim
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    ln -s ~/.vim/vimrc ~/.vimrc
    mkdir ~/.vim/colors
    curl -sL https://github.com/sjl/badwolf/raw/master/colors/badwolf.vim > ~/.vim/colors/badwolf.vim
    sed -i 's/colorscheme github/colorscheme badwolf/g' ~/.vimrc
    vim +PluginInstall +qall

    # setup tmux
    cp /vagrant/setup/.tmux.conf ~/.

    #update default shell to zsh
    sudo sed -i -e 's|/home/vagrant:/bin/bash|/home/vagrant:/usr/bin/zsh|g' /etc/passwd

    #compress file as much as possible
    sudo apt-get clean
    sudo dd if=/dev/zero of=/EMPTY bs=1M
    sudo rm -f /EMPTY
  SCRIPT
end
