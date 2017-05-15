BOX_NAME=dev-vm-rails5
USERNAME=ac21
RUBY_VER=$(shell (head -n 1 .ruby-version))
PROVIDER=virtualbox
PACKAGE_PATH=./package.box

CWD=$(shell pwd)

setup:
	bundle install
	vagrant box update && vagrant up

package:
	vagrant package --base dev-vm-rails5-base --output $(PACKAGE_PATH)

clean:
	rm *.box

upload_new_version: create_version_and_provider upload_file
	echo "upload completed"

create_version_and_provider:
	bundle exec vagrant_cloud create_version --username $(USERNAME) --token $(VAGRANT_CLOUD_TOKEN) --box $(BOX_NAME) --version $(BOX_VERSION)
	bundle exec vagrant_cloud create_provider --username $(USERNAME) --token $(VAGRANT_CLOUD_TOKEN) --box $(BOX_NAME) --version $(BOX_VERSION)

upload_file:
	bundle exec vagrant_cloud upload_file --username $(USERNAME) --token $(VAGRANT_CLOUD_TOKEN) --box $(BOX_NAME) --version $(BOX_VERSION) --provider_file_path $(PACKAGE_PATH)

