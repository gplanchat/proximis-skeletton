##
## Makefile
##
-include .env
export

RED=033[31m
GREEN=033[32m
YELLOW=033[33m
BLUE=033[34m
PURPLE=033[35m
CYAN=033[36m
GREY=033[37m
NC=033[0m

BUILD=bin/satellite build

help: ## Show this help.
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

.PHONY: build
build: ## Build all pipelines
build: build-benefications build-brand build-collection build-cross-selling build-files build-images build-product build-section build-sku

.PHONY: clean
clean: ## Clean all pipeline generated code
clean: clean-benefications clean-brand clean-collection clean-cross-selling clean-files clean-images clean-product clean-section clean-sku

.PHONY: all
all: ## Start sku pipeline
all: build benefications brand collection cross-selling files images product section sku

.PHONY: docker-start
docker-start: ## Start the docker stack
docker-start:
	docker compose up -d

.PHONY: docker-stop
docker-stop: ## Stop the docker stack
docker-stop:
	docker compose down

composer.lock: composer.json
	composer update

vendor: composer.json
	composer install

install: vendor composer.lock

src/%/build: src/%/satellite.yaml
	@echo "\${GREEN}- Build and start $* pipeline\${NC}"
	$(BUILD) src/$*/satellite.yaml

src/%/simple/build: src/%/satellite.yaml
	@echo "\${GREEN}- Build and start $* (for products and variants) pipeline\${NC}"
	$(BUILD) src/$*/simple/satellite.yaml

src/%/model/build: src/%/satellite.yaml
	@echo "\${GREEN}- Build and start $* (for product models) pipeline\${NC}"
	$(BUILD) src/$*/model/satellite.yaml

.PHONY: build-benefications
build-benefications: ## Build benefications pipeline
build-benefications: src/benefications/build

.PHONY: clean-benefications
clean-benefications: ## Clean benefications pipeline generated code
clean-benefications:
	rm -rf src/benefications/build

.PHONY: benefications
benefications: ## Run benefications pipeline
benefications: src/benefications/build
	php src/benefications/build/function.php

.PHONY: build-brand
build-brand: ## Build brand pipeline
build-brand: src/brand/build

.PHONY: clean-brand
clean-brand: ## Clean brand pipeline generated code
clean-brand:
	rm -rf src/brand/build

.PHONY: brand
brand: ## Run brand pipeline
brand: src/brand/build
	php src/brand/build/function.php

.PHONY: build-collection
build-collection: ## Build collection pipeline
build-collection: src/collection/build

.PHONY: clean-collection
clean-collection: ## Clean collection pipeline generated code
clean-collection:
	rm -rf src/collection/build

.PHONY: collection
collection: ## Run collection pipeline
collection: src/collection/build
	php src/collection/build/function.php

.PHONY: build-cross-selling
build-cross-selling: ## Build cross-selling pipeline
build-cross-selling: src/cross-selling/simple/build src/cross-selling/model/build

.PHONY: clean-cross-selling
clean-cross-selling: ## Clean cross-selling pipeline generated code
clean-cross-selling:
	rm -rf src/cross-selling/simple/build src/cross-selling/model/build

.PHONY: cross-selling
cross-selling: ## Run cross-selling pipeline
cross-selling: src/cross-selling/build
	php src/cross-selling/model/build/function.php
	php src/cross-selling/simple/build/function.php

.PHONY: build-files
build-files: ## Build files pipeline
build-files: src/files/simple/build src/files/model/build

.PHONY: clean-files
clean-files: ## Clean files pipeline generated code
clean-files:
	rm -rf src/files/simple/build src/files/model/build

.PHONY: files
files: ## Run files pipeline
files: src/files/build
	php src/files/model/build/function.php
	php src/files/simple/build/function.php

.PHONY: build-images
build-images: ## Build images pipeline
build-images: src/images/simple/build src/images/model/build

.PHONY: clean-images
clean-images: ## Clean images pipeline generated code
clean-images:
	rm -rf src/images/simple/build src/images/model/build

.PHONY: images
images: ## Run images pipeline
images: src/images/simple/build src/images/model/build
	php src/images/model/build/function.php
	php src/images/simple/build/function.php

.PHONY: build-product
build-product: ## Build product pipeline
build-product: src/product/simple/build src/product/model/build

.PHONY: clean-product
clean-product: ## Clean product pipeline generated code
clean-product:
	rm -rf src/product/simple/build src/product/model/build

.PHONY: product
product: ## Run product pipeline
product: src/product/simple/build src/product/model/build
	php src/product/model/build/function.php
	php src/product/simple/build/function.php

.PHONY: build-section
build-section: ## Build section pipeline
build-section: src/section/build

.PHONY: clean-section
clean-section: ## Clean section pipeline generated code
clean-section:
	rm -rf src/section/build

.PHONY: section
section: ## Run section pipeline
section: src/section/build
	php src/section/build/function.php

.PHONY: build-sku
build-sku: ## Build sku pipeline
build-sku: src/sku/build

.PHONY: clean-sku
clean-sku: ## Clean sku pipeline generated code
clean-sku:
	rm -rf src/sku/build

.PHONY: sku
sku: ## Run sku pipeline
sku: src/sku/build
	php src/sku/build/function.php
