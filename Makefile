ARCH           ?= x86_64
DISTRO         ?= rosa13

ROOTFS_DIR     = rootfs-$(ARCH)
ARCHIVE_DIR    = artifacts
SCRIPT         = ./rstrap.sh
IMAGE_NAME     = rosalab/$(DISTRO)

ABS_ROOTFS     = $(shell realpath $(ROOTFS_DIR) 2>/dev/null || echo $(PWD)/$(ROOTFS_DIR))
ABS_ARCHIVE    = $(shell realpath $(ARCHIVE_DIR) 2>/dev/null || echo $(PWD)/$(ARCHIVE_DIR))

SUPPORTED_ARCHS = x86_64 aarch64 riscv64 loongarch64


all: $(SUPPORTED_ARCHS:%=image-%)


rootfs-archive:
	@mkdir -p $(ROOTFS_DIR) $(ARCHIVE_DIR)
	@echo "==> Creating rootfs for $(ARCH)"
	$(SCRIPT) --arch=$(ARCH) \
	          --distro=$(DISTRO) \
	          --path=$(ABS_ROOTFS) \
	          --archive=$(ABS_ARCHIVE)
	@echo "==> Rootfs created: $(ABS_ARCHIVE)/rootfs.$(ARCH).tar.xz"


image: rootfs-archive
	@echo "==> Building container image $(IMAGE_NAME):$(ARCH)"
	docker import $(ABS_ARCHIVE)/rootfs.$(ARCH).tar.xz $(IMAGE_NAME):$(ARCH)
	@if [ "$(ARCH)" = "x86_64" ]; then \
	    echo "==> Tagging latest"; \
	    docker tag $(IMAGE_NAME):x86_64 $(IMAGE_NAME):latest; \
	fi


image-%:
	$(MAKE) ARCH=$* DISTRO=$(DISTRO) image


clean:
	rm -rf $(ROOTFS_DIR) $(ARCHIVE_DIR)/rootfs.*.tar.xz
