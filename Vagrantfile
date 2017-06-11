# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-16.04"

  config.vm.box_check_update = false

  config.vm.provider "virtualbox" do |vb|
      vb.name = "dev-vm-rails5-base"
      vb.memory = "2048"
      vb.cpus = 2
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
    #shell and rbenv dependencies
    apt-get install -y build-essential zsh zsh-syntax-highlighting

    # ruby dependencies
    apt-get install -y libssl-dev libreadline-dev zlib1g-dev

    # sqllite, nodejs and yaml libraries
    apt-get install -y libyaml-dev libsqlite3-dev sqlite3 nodejs

    # postgres & redis
    apt-get install -y postgresql-9.5 postgresql-common libpq-dev redis-server

    # config postgres for md5 login locally
    sed -i -E 's/(local.+all.+all.+)peer/\1md5/g' /etc/postgresql/9.5/main/pg_hba.conf

    # conf postgres to be accessible by host system
    sed -i -E 's|(host.+all.+all.+)127.0.0.1/32|\1  0.0.0.0/0 |g' /etc/postgresql/9.5/main/pg_hba.conf
    sed -i "59ilisten_addresses = '*'" /etc/postgresql/9.5/main/postgresql.conf

    #compres file as much as possible
    apt-get clean
    dd if=/dev/zero of=/EMPTY bs=1M
    rm -f /EMPTY
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

    rbenv install 2.2.3
    rbenv install 2.3.4
    rbenv install 2.4.1
    rbenv global 2.4.1

    rbenv rehash

    # install bundler
    gem install bundler

    git clone https://github.com/scrooloose/vimfiles.git ~/.vim
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    mv ~/.vim/vimrc ~/.vimrc
    mkdir ~/.vim/colors
    curl -sL https://github.com/sjl/badwolf/raw/master/colors/badwolf.vim > ~/.vim/colors/badwolf.vim
    sed -i 's/colorscheme github/colorscheme badwolf/g' ~/.vimrc
    sed -i "/vim-gutentags/d" ~/.vimrc
    vim +PluginInstall +qall

    # setup tmux
    cp /vagrant/setup/.tmux.conf ~/.

    #update default shell to zsh
    sudo sed -i -e 's|/home/vagrant:/bin/bash|/home/vagrant:/usr/bin/zsh|g' /etc/passwd
  SCRIPT
end
