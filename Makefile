WORK_DIR := $(shell pwd)
RELEASE_DIR := $(WORK_DIR)/release

.PHONY: dep vim git-get libt bootstrap build prepare create deploy

dep:
	@echo install git ncurses-devel
	sudo yum install -y git ncurses-devel
	@echo install Development Tools
	sudo yum groupinstall "Development Tools"

git-get:
	@echo get vim source code
	git clone https://github.com/vim/vim.git

vim:
	@echo make vim binary
	cd vim && \
	./configure --with-features=normal --prefix=$(RELEASE_DIR) && \
	make && \
	make install

libt:
	@echo copy libtinfo
	mkdir -p $(RELEASE_DIR)/lib
	ldd ${RELEASE_DIR}/bin/vim | grep libtinfo | awk '{system("cp "$3" release/lib")}'
	ls release/lib

bootstrap:
	@echo copy bootstrap
	cp bootstrap $(RELEASE_DIR)
	chmod +x $(RELEASE_DIR)/bootstrap

build:
	@echo archive files
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
