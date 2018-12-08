WORK_DIR := $(shell pwd)
RELEASE_DIR := $(WORK_DIR)/release

.PHONY: dep vim git-get build prepare create deploy

dep:
	sudo yum install -y git ncurses-devel
	sudo yum groupinstall "Development Tools"

git-get:
	git clone https://github.com/vim/vim.git

vim:
	cd vim && \
	./configure --with-features=normal --prefix=$(RELEASE_DIR) && \
	make && \
	make install
	cd $(RELEASE_DIR) && \
	mkdir lib && \
	ldd bin/vim | grep libtinfo | awk '{print $3}' >> deps && \
	while read line; do cp $item lib/
	cp bootstrap $(RELEASE_DIR)

build:
	cd $(RELEASE_DIR) && \
	zip vim.zip bootstrap bin/vim && \
	zip -r vim.zip lib/

prepare:
	aws s3api put-object --bucket $(BUCKET) --key $(FILE_NAME) --body $(RELEASE)/vim.zip

create:
	aws lambda create-function \
	  --function-name $(FUNCTION) \
	  --role $(ROLE_ARN) \
	  --handler noHandler \
	  --code S3Bucket=$(BUCKET),S3Key=$(FILE_NAME)

deploy:
	aws lambda update-function-code \
	  --function-name $(FUNCTION) \
	  --s3-bucket $(BUCKET) \
	  --s3-key $(FILE_NAME)
