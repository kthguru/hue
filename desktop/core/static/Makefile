#
# (c) Copyright 2011 Cloudera, Inc. All rights reserved.
#

# ------------------------------------------------------------
# make or make dist
#	1 compiles node and the CSS/LESS compiler.
#	2 builds CSS files from the LESS source code.
#       3 builds, concatenates, and gzips all the JavaScript files.
#
# make clean dist
# 	1 removes the env directory.
#	2 make dist
# ------------------------------------------------------------
TOP := $(realpath .)

CP := cp
INSTALL := install
MKDIR := mkdir
TAR := tar
RMF := rm -rf
GZIP := gzip -f -c

REPOS_DIR        := $(TOP)/repos
EXT_DIR          := $(TOP)/ext

JQUERY_DIR  := $(EXT_DIR)/jquery
JQUERY_PLUGINS_DIR := $(JQUERY_DIR)/plugins

# External nodejs files; this is needed by the Less CSS compiler.
NODE_VERSION   := node-v0.4.11
NODE_URL       := http://nodejs.org/dist/$(NODE_VERSION).tar.gz
NODE_TAR_GZ    := $(REPOS_DIR)/$(NODE_VERSION).tar.gz
NODE_TMP_DIR   := $(TOP)/$(NODE_VERSION)
NODE_CMD       := $(TOP)/env/bin/node

# External less.js files, the Less CSS compiler.
LESSCSS_TAR_GZ_URL := https://github.com/cloudhead/less.js/tarball/master
LESSCSS_TAR_GZ     := $(REPOS_DIR)/cloudhead-master.tar.gz
LESSCSS_TMP_DIR    := $(TOP)/cloudhead-less.js-*
LESSCSS_DIR        := $(TOP)/env/lesscss
LESSCSS_CMD        := $(LESSCSS_DIR)/bin/lessc

RHINO ?= java -classpath repos/rhino/js.jar org.mozilla.javascript.tools.shell.Main
YUICOMPRESSOR ?= java -jar repos/yuicompressor/yuicompressor-2.4.6.jar

dist: gzip css

# Always clean up the env environment
clean:
	$(RMF) $(TOP)/env

# make jslint_all performs validation on all *.js files under the cloudera
# folder.
jslint_all:
	@@echo "Checking against JSLint..."
	@@${RHINO} ./jslint-check.js $(shell find cloudera -name "*.js")

# make jslint files="file1 file2" performs validation on only file1 and file2.
jslint:
	@@echo "Checking against JSLint..."
	@@${RHINO} ./jslint-check.js $(files)

# Installs jscoverage
env/bin/jscoverage:
	tar -jxvf repos/jscoverage-0.5.1.tar.bz2
	cd jscoverage-0.5.1 && ./configure --prefix=${TOP}/env && make && make install
	rm -rf jscoverage-0.5.1

jscompress: $(JQUERY_PLUGINS_DIR)/jquery-plugins-all-3.7.min.js

$(JQUERY_PLUGINS_DIR)/jquery-plugins-all-3.7.min.js: FORCE
	@cat		 $(JQUERY_DIR)/js/jquery-ui-1.8.16.custom.min.js > $@
	@cat		 $(JQUERY_PLUGINS_DIR)/jquery-layout-1.3.0.min.js >> $@
	@cat		 $(JQUERY_PLUGINS_DIR)/jquery-ui-timepicker-addon-license.txt >> $@
	@cat		 $(JQUERY_PLUGINS_DIR)/jquery-ui-timepicker-addon-0.9.6.min.js >> $@
	@cat		 $(JQUERY_PLUGINS_DIR)/jquery.dataTables-1.8.1.min.js >> $@
	@cat		 $(JQUERY_PLUGINS_DIR)/TableTools-2.0.1.min.js >> $@
	${YUICOMPRESSOR} $(JQUERY_PLUGINS_DIR)/ZeroClipboard-2.0.1.js  >> $@
	@cat		 $(JQUERY_PLUGINS_DIR)/jquery.address-1.4.min.js >> $@
	@cat		 $(JQUERY_PLUGINS_DIR)/jquery-tools-1.2.5.min.js >> $@


# This gets the latest cloudhead/less.js packages from github.com
# See http://www.pimcore.org/wiki/display/PIMCORE/Install+lessc+on+your+server+(Debian)
get_less_js:
	@curl $(LESSCSS_TAR_GZ_URL) -o $(LESSCSS_TAR_GZ)

# This gets the last known stable version of node
# See http://nodejs.org
get_node:
	@curl $(NODE_TAR_GZ_URL) -o $(NODE_TAR_GZ)

# Compile and install node
$(NODE_CMD):
	@tar -zxf $(NODE_TAR_GZ)
	@cd $(NODE_TMP_DIR) && ./configure --prefix=$(TOP)/env && make && make install
	@rm -rf $(NODE_TMP_DIR)
	@echo $(NODE_TAR_GZ) Installed.

# Compile and install Less CSS compiler.
$(LESSCSS_CMD): $(NODE_CMD)
	@tar -zxf $(LESSCSS_TAR_GZ)
	@rm -rf $(LESSCSS_DIR)
	@mv $(LESSCSS_TMP_DIR) $(LESSCSS_DIR)

$(TOP)/cms/css/*.css: $(LESSCSS_CMD) FORCE
	@echo Building $@
	@PATH=$(TOP)/env/bin:$(PATH) $(LESSCSS_CMD) $(subst cms/css,cms/css/less/cms, $(subst .css,.less,$@)) > $@

CSS_FILES:= $(TOP)/cms/css/cms.css \

css: $(CSS_FILES)

GZIP_FILES:= $(JQUERY_DIR)/css/smoothness/jquery-ui-1.8.16.custom.css.gz \
	$(JQUERY_DIR)/js/jquery-1.6.2.min.js.gz \
	$(JQUERY_PLUGINS_DIR)/jquery-plugins-all-3.7.min.js.gz \

gzip: $(GZIP_FILES)

%.css.gz: %.css
	$(GZIP) $< > $@

%.js.gz: %.js
	$(GZIP) $< > $@

.PHONY: FORCE update jscompress get_less_js get_node clean gzip css
