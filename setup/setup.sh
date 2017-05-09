# configure ZSH and make default prompt
cp /vagrant/setup/.zshrc ~/.zshrc
mkdir ~/.bin
curl -sL https://github.com/djl/vcprompt/raw/master/bin/vcprompt > ~/.bin/vcprompt
chmod 755 ~/.bin/vcprompt
ln -s /usr/bin/python3 $HOME/.bin/python

echo "setting shell to zsh; password required"
chsh --shell $(which zsh)

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

# install rails
gem install rails
gem install bundler

rbenv rehash

# compress file as much as possible
sudo apt-get clean
sudo dd if=/dev/zero of=/EMPTY bs=1M
sudo rm -f /EMPTY
rm $HISTFILE && exit
