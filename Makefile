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

src/cli-pipeline-akeneo-to-csv-%/build:
	@echo "\${GREEN}- Build and start $* pipeline\${NC}"
	$(BUILD) src/cli-pipeline-akeneo-to-csv-$*/satellite.yaml

src/cli-pipeline-akeneo-to-csv-%/simple/build:
	@echo "\${GREEN}- Build and start $* (simple) pipeline\${NC}"
	$(BUILD) src/cli-pipeline-akeneo-to-csv-$*/simple/satellite.yaml

src/cli-pipeline-akeneo-to-csv-%/model/build:
	@echo "\${GREEN}- Build and start $* (model) pipeline\${NC}"
	$(BUILD) src/cli-pipeline-akeneo-to-csv-$*/model/satellite.yaml

.PHONY: build-benefications
build-benefications: ## Build benefications pipeline
build-benefications: src/cli-pipeline-akeneo-to-csv-benefications/build

.PHONY: clean-benefications
clean-benefications: ## Clean benefications pipeline generated code
clean-benefications:
	rm -rf src/cli-pipeline-akeneo-to-csv-benefications/build

.PHONY: benefications
benefications: ## Run benefications pipeline
benefications: src/cli-pipeline-akeneo-to-csv-benefications/build
	php src/cli-pipeline-akeneo-to-csv-benefications/build/function.php

.PHONY: build-brand
build-brand: ## Build brand pipeline
build-brand: src/cli-pipeline-akeneo-to-csv-brand/build

.PHONY: clean-brand
clean-brand: ## Clean brand pipeline generated code
clean-brand:
	rm -rf src/cli-pipeline-akeneo-to-csv-brand/build

.PHONY: brand
brand: ## Run brand pipeline
brand: src/cli-pipeline-akeneo-to-csv-brand/build
	php src/cli-pipeline-akeneo-to-csv-brand/build/function.php

.PHONY: build-collection
build-collection: ## Build collection pipeline
build-collection: src/cli-pipeline-akeneo-to-csv-collection/build

.PHONY: clean-collection
clean-collection: ## Clean collection pipeline generated code
clean-collection:
	rm -rf src/cli-pipeline-akeneo-to-csv-collection/build

.PHONY: collection
collection: ## Run collection pipeline
collection: src/cli-pipeline-akeneo-to-csv-collection/build
	php src/cli-pipeline-akeneo-to-csv-collection/build/function.php

.PHONY: build-cross-selling
build-cross-selling: ## Build cross-selling pipeline
build-cross-selling: src/cli-pipeline-akeneo-to-csv-cross-selling/simple/build src/cli-pipeline-akeneo-to-csv-cross-selling/model/build

.PHONY: clean-cross-selling
clean-cross-selling: ## Clean cross-selling pipeline generated code
clean-cross-selling:
	rm -rf src/cli-pipeline-akeneo-to-csv-cross-selling/simple/build src/cli-pipeline-akeneo-to-csv-cross-selling/model/build

.PHONY: cross-selling
cross-selling: ## Run cross-selling pipeline
cross-selling: src/cli-pipeline-akeneo-to-csv-cross-selling/build
	php src/cli-pipeline-akeneo-to-csv-cross-selling/model/build/function.php
	php src/cli-pipeline-akeneo-to-csv-cross-selling/simple/build/function.php

.PHONY: build-files
build-files: ## Build files pipeline
build-files: src/cli-pipeline-akeneo-to-csv-files/simple/build src/cli-pipeline-akeneo-to-csv-files/model/build

.PHONY: clean-files
clean-files: ## Clean files pipeline generated code
clean-files:
	rm -rf src/cli-pipeline-akeneo-to-csv-files/simple/build src/cli-pipeline-akeneo-to-csv-files/model/build

.PHONY: files
files: ## Run files pipeline
files: src/cli-pipeline-akeneo-to-csv-files/build
	php src/cli-pipeline-akeneo-to-csv-files/model/build/function.php
	php src/cli-pipeline-akeneo-to-csv-files/simple/build/function.php

.PHONY: build-images
build-images: ## Build images pipeline
build-images: src/cli-pipeline-akeneo-to-csv-images/simple/build src/cli-pipeline-akeneo-to-csv-images/model/build

.PHONY: clean-images
clean-images: ## Clean images pipeline generated code
clean-images:
	rm -rf src/cli-pipeline-akeneo-to-csv-images/simple/build src/cli-pipeline-akeneo-to-csv-images/model/build

.PHONY: images
images: ## Run images pipeline
images: src/cli-pipeline-akeneo-to-csv-images/simple/build src/cli-pipeline-akeneo-to-csv-images/model/build
	php src/cli-pipeline-akeneo-to-csv-images/model/build/function.php
	php src/cli-pipeline-akeneo-to-csv-images/simple/build/function.php

.PHONY: build-product
build-product: ## Build product pipeline
build-product: src/cli-pipeline-akeneo-to-csv-product/simple/build src/cli-pipeline-akeneo-to-csv-product/model/build

.PHONY: clean-product
clean-product: ## Clean product pipeline generated code
clean-product:
	rm -rf src/cli-pipeline-akeneo-to-csv-product/simple/build src/cli-pipeline-akeneo-to-csv-product/model/build

.PHONY: product
product: ## Run product pipeline
product: src/cli-pipeline-akeneo-to-csv-product/simple/build src/cli-pipeline-akeneo-to-csv-product/model/build
	php src/cli-pipeline-akeneo-to-csv-product/model/build/function.php
	php src/cli-pipeline-akeneo-to-csv-product/simple/build/function.php

.PHONY: build-section
build-section: ## Build section pipeline
build-section: src/cli-pipeline-akeneo-to-csv-section/build

.PHONY: clean-section
clean-section: ## Clean section pipeline generated code
clean-section:
	rm -rf src/cli-pipeline-akeneo-to-csv-section/build

.PHONY: section
section: ## Run section pipeline
section: src/cli-pipeline-akeneo-to-csv-section/build
	php src/cli-pipeline-akeneo-to-csv-section/build/function.php

.PHONY: build-sku
build-sku: ## Build sku pipeline
build-sku: src/cli-pipeline-akeneo-to-csv-sku/build

.PHONY: clean-sku
clean-sku: ## Clean sku pipeline generated code
clean-sku:
	rm -rf src/cli-pipeline-akeneo-to-csv-sku/build

.PHONY: sku
sku: ## Run sku pipeline
sku: src/cli-pipeline-akeneo-to-csv-sku/build
	php src/cli-pipeline-akeneo-to-csv-sku/build/function.php
