# make-kit.mk for ps1-foo
#  This makefile is included by the root shellkit Makefile
#  It defines values that are kit-specific.
#  You should edit it and keep it source-controlled.

# The shellkit/ tooling naturally evolves out from under the dependent kits.  ShellkitSetupVers allows
# detecting the need for refresh of templates/* derived files.  To bump the root version, 
# zap all templates/* containing 'ShellkitTemplateVers' constants and changes to the corresponding dependent kits
# Note that within templates/* there may be diverse versions in upstream shellkit, they don't all have to match,
# but the derived copies should be sync'ed with upstream as needed.
ShellkitTemplateVers=2

# TODO: update kit_depends to include anything which
#   might require the kit version to change as seen
#   by the user -- i.e. the files that get installed,
#   or anything which generates those files.
kit_depends := \
    bin/ps1-foo.bashrc \
    bin/ps1-foo.sh

.PHONY: publish publish-draft
pcw_depends := $(shell $(MAKE) -s -C ../prompt-command-wrap pcw-deps)
build_depends += $(../prompt-command-wrap/tmp/promp-command-wrap.bashrc)

../prompt-command-wrap/tmp/prompt-command-wrap.bashrc: $(pcw_depends)
	@[[ -d ../prompt-command-wrap/tmp ]] || {
		echo "ERROR: dependency ../prompt-command-wrap must be installed first." >&2
		exit 19
	}
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

publish-draft: pre-publish publish-common release-draft-upload release-list
	cat tmp/draft-url
	@echo ">>>> publish complete OK. (DRAFT - you must manually publish it from github release page)  <<<"
