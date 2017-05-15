# configure ZSH and make default prompt
cp /vagrant/setup/.zshrc ~/.
mkdir ~/.bin
curl -sL https://github.com/djl/vcprompt/raw/master/bin/vcprompt > ~/.bin/vcprompt
chmod 755 ~/.bin/vcprompt
ln -s /usr/bin/python3 $HOME/.bin/python

cd ~
echo "setting shell to zsh; password required"
chsh --shell $(which zsh)

# setup VIM
git clone https://github.com/scrooloose/vimfiles.git ~/.vim
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
mv ~/.vim/vimrc ~/.vimrc
mkdir ~/.vim/colors
curl -sL https://github.com/sjl/badwolf/raw/master/colors/badwolf.vim > ~/.vim/colors/badwolf.vim
sed -i '/colorscheme github/c\colorscheme badwolf' ~/.vimrc
sed -i "/vim-gutentags/d" ~/.vimrc
vim +PluginInstall +qall

# stup tmux
cp /vagrant/setup/.tmux.conf ~/.

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

# install rails
gem install rails
gem install bundler

# configure pg
sudo sed -i '90d' /etc/postgresql/9.5/main/pg_hba.conf
sudo sed -i '90ilocal   all             all                                     md5' /etc/postgresql/9.5/main/pg_hba.conf


# compress file as much as possible
sudo apt-get clean
sudo dd if=/dev/zero of=/EMPTY bs=1M
sudo rm -f /EMPTY
