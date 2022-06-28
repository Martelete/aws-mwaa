#
# Variables
#

SUBDIRS := $(shell find . -mindepth 2 -type f -name Makefile | grep -v \\.terraform | grep -v examples | grep -v test)
EXAMPLE_SUBDIRS := $(shell find examples -mindepth 2 -type f -name Makefile | grep -v \\.terraform)

#####################################################################################
###                                Build  targets                                 ###
#####################################################################################

all: $(SUBDIRS) $(EXAMPLE_SUBDIRS)

#
# Process modules targets
#
# ###################################################################################
#

$(SUBDIRS):
	@echo "-------------------------------------------------------------------------"
	@echo "Processing $@: $(MAKECMDGOALS)"
	@echo "-------------------------------------------------------------------------"
	@$(MAKE) -C $(@:Makefile=) --no-print-directory --silent $(MAKECMDGOALS)

#
# Process examples targets
#
# ###################################################################################
#

$(EXAMPLE_SUBDIRS):
	@echo "-------------------------------------------------------------------------"
	@echo "Processing $@: $(MAKECMDGOALS)"
	@echo "-------------------------------------------------------------------------"
ifneq ($(MAKECMDGOALS),clean)
	@$(MAKE) -C $(@:Makefile=) --no-print-directory --silent fmt init validate
else
	@$(MAKE) -C $(@:Makefile=) --no-print-directory --silent $(MAKECMDGOALS)
endif

#####################################################################################
###                                 Help  targets                                 ###
#####################################################################################

.PHONY: help
help:
	@echo "\nAvailable targets:"
	@echo ""
	@echo "  make                - execute default targets for all modules and examples"
	@echo "  make clean          - cleanup all modules and examples"
	@echo ""
	@echo "  make help           - show this"
	@echo ""

.PHONY: clean
clean: $(SUBDIRS) $(EXAMPLE_SUBDIRS)

.PHONY: all $(SUBDIRS) $(EXAMPLE_SUBDIRS)
