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

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  config.vm.provision "shell", inline: <<-SHELL
    #shell and rbenv dependencies
    apt-get install -y build-essential zsh zsh-syntax-highlighting

    # ruby dependencies
    apt-get install -y libssl-dev libreadline-dev zlib1g-dev

    # rails dependencies
    apt-get install -y libyaml-dev libsqlite3-dev sqlite3 nodejs

    #postgres
    apt-get install -y postgresql-9.5 postgresql-common libpq-dev

    #config postgres for md5 login locally
    sudo sed -i '90d' /etc/postgresql/9.5/main/pg_hba.conf
    sudo sed -i '90ilocal   all             all                                     md5' /etc/postgresql/9.5/main/pg_hba.conf

    #compres file as much as possible
    sudo apt-get clean
    sudo dd if=/dev/zero of=/EMPTY bs=1M
    sudo rm -f /EMPTY
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

    #rbenv install 2.2.3
    #rbenv install 2.3.4
    #rbenv install 2.4.1
    #rbenv global 2.4.1

    rbenv rehash

    # install rails
    gem install rails
    gem install bundler

    git clone https://github.com/scrooloose/vimfiles.git ~/.vim
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    mv ~/.vim/vimrc ~/.vimrc
    mkdir ~/.vim/colors
    curl -sL https://github.com/sjl/badwolf/raw/master/colors/badwolf.vim > ~/.vim/colors/badwolf.vim
    sed -i '/colorscheme github/c\\colorscheme badwolf' ~/.vimrc
    sed -i "/vim-gutentags/d" ~/.vimrc
    vim +PluginInstall +qall

    # setup tmux
    cp /vagrant/setup/.tmux.conf ~/.
  SCRIPT
end
