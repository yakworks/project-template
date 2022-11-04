# check for build/shipkit and clone if not there, this should come first
SHIPKIT_DIR = build/shipkit
$(shell [ ! -e $(SHIPKIT_DIR) ] && git clone -b v2.0.11 https://github.com/yakworks/shipkit.git $(SHIPKIT_DIR) --depth=1 >/dev/null 2>&1)
# Shipkit.make first, which does all the lifting to create makefile.env for the BUILD_VARS
include $(SHIPKIT_DIR)/Shipkit.make
include $(SHIPKIT_MAKEFILES)/circle.make
include $(SHIPKIT_MAKEFILES)/vault.make
include $(SHIPKIT_MAKEFILES)/git-tools.make
include $(SHIPKIT_MAKEFILES)/gradle-tools.make
include $(SHIPKIT_MAKEFILES)/ship-version.make

# for testing circle image. set up .env or export both GITHUB_TOKEN and the base64 enocded GPG_KEY from lastpass.
docker.circle.shell:
	docker volume create gradle_cache
	docker run -it --rm \
	-e GITHUB_TOKEN \
	-e GPG_KEY \
	-v gradle_cache:/root/.gradle \
	-v "$$PWD":/root/project \
	$(DOCKER_SHELL) $(BIN_BASH)
	#	-v ~/.gradle_docker:/root/.gradle \
