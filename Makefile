all: install prepare

install:
	bundle install --path=vendor/bundle
	bundle exec pod check || bundle exec pod install

prepare:
	echo $(GOO_APP_ID) > GooConfig.txt
