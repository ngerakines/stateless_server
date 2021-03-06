LIBDIR=`erl -eval 'io:format("~s~n", [code:lib_dir()])' -s init stop -noshell`
VERSION=0.1.2

all:
	mkdir -p ./ebin/
	(cd src; $(MAKE))

test: all
	(cd t; $(MAKE))
	prove t/*.t

clean:
	(cd t; $(MAKE) clean)
	(cd src; $(MAKE) clean)

package: clean
	@mkdir stateless_server-$(VERSION)/ && cp -rf ebin src examples support Makefile stateless_server-$(VERSION)
	@COPYFILE_DISABLE=true tar zcf stateless_server-$(VERSION).tgz stateless_server-$(VERSION)
	@rm -rf stateless_server-$(VERSION)/

install:
	mkdir -p $(prefix)/$(LIBDIR)/stateless_server-$(VERSION)/ebin
	for i in ebin/*; do install $$i $(prefix)/$(LIBDIR)/stateless_server-$(VERSION)/$$i ; done
