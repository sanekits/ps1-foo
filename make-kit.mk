# make-kit.mk for ps1-foo
#  This makefile is included by the root shellkit Makefile
#  It defines values that are kit-specific.
#  You should edit it and keep it source-controlled.

# TODO: update kit_depends to include anything which
#   might require the kit version to change as seen
#   by the user -- i.e. the files that get installed,
#   or anything which generates those files.
kit_depends := \
    bin/ps1-foo.bashrc \
    bin/ps1-foo.sh

pcw_depends := $(shell $(MAKE) -s -C ../prompt-command-wrap pcw-deps)
build_depends += $(../prompt-command-wrap/tmp/promp-command-wrap.bashrc)

../prompt-command-wrap/tmp/prompt-command-wrap.bashrc: $(pcw_depends)
	$(MAKE) -s -C ../prompt-command-wrap build
bin/prompt-command-wrap.bashrc: ../prompt-command-wrap/tmp/prompt-command-wrap.bashrc
	cp $< $@

.PHONY: publish


# TODO: when all legacy kits are migrated, move this dependency
# into the main Makefile
#publish-common: conformity-check
publish: pre-publish publish-common release-upload release-list
	cat tmp/draft-url
	@echo ">>>> publish complete OK. (FINAL)  <<<"

build:
	@echo Build OK
