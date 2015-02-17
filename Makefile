KERNEL_BASE?=../linux
KERNEL_USR=$(KERNEL_BASE)/usr

KLIBC_BASE?=../klibc

PREFIX?=mipsel-unknown-elf-

all: klibc-install cpio-gen

klibc-install:
	make -C $(KLIBC_BASE) \
		KLIBCKERNELSRC=$(KERNEL_BASE) \
		KLIBCARCH=tsar \
		CROSS_COMPILE=$(PREFIX) \
		INSTALLROOT=$(PWD)/klibc install

cpio-gen: initramfs_list
	$(KERNEL_USR)/gen_init_cpio $< > $(KERNEL_USR)/initramfs_data.cpio

SOLIBFILE=$(KLIBC_BASE)/usr/klibc/libc.so.hash
SOLIBHASH=$(shell cat $(SOLIBFILE))

initramfs_list: initramfs_list_xxx $(SOLIBFILE)
	sed 's/XXXXXXXXXX/$(SOLIBHASH)/g' < $< > $@


clean:
	-rm -rf klibc initramfs_list

distclean: clean
	make -C $(KLIBC_BASE) clean
