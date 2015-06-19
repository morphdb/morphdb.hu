PROJECT=morphdb_hu

DEBUG_LEVEL?=1
DOUBLE_FLAGS?=true
HUNLEXMAKEFILE=/usr/local/lib/HunlexMakefile
#HUNLEX=../../hunlex/src/hunlex
#TAG_DELIM

RELEASE=

all: in new resources

GUESS=guess
CLOSE=sentint conj ono adv greeting prep prev punct num advpron pronoun postp+case irregulars art det missing acro numbers
ADDITIONS=
NAMED_ENTITY=proper_noun proper_noun_geo
#NAMED_ENTITY=proper_noun proper_noun_geo ner
OPEN=peeta $(NAMED_ENTITY)

RAW=# letter roman_num
LEXICONS=$(OPEN) $(ADDITIONS) $(CLOSE) $(GUESS)
LEXICON=tmp/morphdb.lexicon

-include $(HUNLEXMAKEFILE)

$(LEXICON):

tmp/morphdb.lexicon: $(LEXICONS:%=in/%.lexicon)  $(RAW:%=tmp/raw.lexicon)
	cat $^ > $@

tmp/raw.lexicon: $(RAW:%=tmp/%.lexicon)
	cat $^ > $@

tmp/%.lexicon: in/%.lexicon
	i=`echo $(*F)|tr 'a-z' 'A-Z'`;\
	grep -v '^#' $< | grep -e '[^ 	]' | sed "s/$$/ OUT: $$i ,;/" > $@

release: LICENCE README AUTHORS ${AFF} ${DIC} doc
	mkdir -p morphdb.hu
	cp -R $^ morphdb.hu/
	tar czvf morphdb.tgz morphdb.hu/*
	rm -rf morphdb.hu/*
	rmdir morphdb.hu

src: LICENCE README AUTHORS doc in
	mkdir -p morphdb.hu
	cp -R $^ morphdb.hu/
	tar czvf morphdb.tgz morphdb.hu/*
	rm -rf morphdb.hu/*
	rmdir morphdb.hu

check:
	test/check tests/*

