BOX_NAME=dev-vm-rails5
USER_NAME=ac21
RUBY_VER=$(shell (head -n 1 .ruby-version))
PROVIDER=virtualbox
BASE_URL=https://atlas.hashicorp.com/api/v1/box/$(USER_NAME)/$(BOX_NAME)
TOKEN_PARAM=-H 'X-Atlas-Token: $(VAGRANT_CLOUD_TOKEN)'
CREATE_VERSION_URL='$(BASE_URL)/versions/' -X POST $(TOKEN_PARAM) -d version[version]='$(VERSION)'
RELEASE_VERSION_URL='https://atlas.hashicorp.com/api/v1/box/$(USER_NAME)/$(BOX_NAME)/version/$(VERSION)/release' -X PUT $(TOKEN_PARAM)
CREATE_PROVIDER_URL='$(BASE_URL)/version/$(VERSION)/providers' -X POST $(TOKEN_PARAM) -d provider[name]='$(PROVIDER)'
GET_BOX_UPLOAD_ENDPOINT_URL='$(BASE_URL)/version/$(VERSION)/provider/$(PROVIDER)/upload' $(TOKEN_PARAM)
ADD_BOX_URL='-X PUT --upload-file $(BOX_FILE_PATH) $(UPLOAD_PATH)'

CWD=$(shell pwd)

package:
	vagrant package --base dev-vm-rails5-base --output package.box

clean:
	rm *.box

create_version:
	#echo "$(CREATE_VERSION_URL)"
	curl $(CREATE_VERSION_URL)

release_version:
	curl $(RELEASE_VERSION_URL)

create_provider:
	curl $(CREATE_PROVIDER_URL)

get_box_upload_endpoint:
	curl $(GET_BOX_UPLOAD_ENDPOINT_URL)

upload_box:
	curl $(ADD_BOX_URL)
