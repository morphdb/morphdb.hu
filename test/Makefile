SZEGED2FREQ = /big1/Language/Hungarian/Freq/Szeged2Korpusz/szeged2.filtered.freq
MSD2KR=../doc/msd2kr
SZEGED2MORPHDB=../doc/szeged2morphdb
RESOURCE=../out/morphdb_hu
RESFILES=${RESOURCE}.aff ${RESOURCE}.dic
OCRESFILE=${RESOURCE}.bin
OCAMORPH=ocamorph

word.oov:	${SZEGED2FREQ} ${RESFILES}
	# kiszuri azokat a szavakat, amiket a morphdb.hu nem ismer
	cat ${SZEGED2FREQ} | lexfilter -S -f2 -r ${RESOURCE} > word.oov

word.oov.lemma.v:	word.oov ${SZEGED2FREQ} ${RESFILES}
	# kiszuri azokat a szavakat, amiket a morphdb.hu nem ismer, de lemmajukat ismeri
	# feltehetoleg ezek nyelvtan hibak
	cat word.oov | lexfilter -s -f 3 -r ${RESOURCE} > word.oov.lemma.v

lemma.oov:
	# kiszuri azokat a lemmakat, amiket a morphdb.hu nem ismer, es lemma gyakorisagot szamol
	cat ${SZEGED2FREQ} | lexfilter -S -f3 -r ${RESOURCE} |  awk 'BEGIN{FS="\t";}{f[$$3]+=$$1;} END{for (l in f) { print f[l] "\t" l;}}' | sort -n -r > lemma.oov 

szeged.hunmorphed:      ${SZEGED2FREQ} ${OCRESFILE}
	# a morphdb.hu val elemzi a szeged lexikont
	cat ${SZEGED2FREQ} | ${OCAMORPH} --bin ${OCRESFILE} --field 2 --count_analyses --tag_sep "	" --tag_preamble "" | \
	awk -f normkr.awk -v kfield=5  > szeged.hunmorphed 

szeged.kr:	${MSD2KR} ${SZEGED2FREQ}  ${SZEGED2MORPHDB}
	cat ${SZEGED2FREQ} |  awk -f msd2kr.awk ${MSD2KR} ${SZEGED2MORPHDB} 2 4 | \
	awk -f normkr.awk -v kfield=5 -v onlyreplace=1 > szeged.kr 

stat:	szeged.hunmorphed szeged.kr
	cat szeged.hunmorphed | cut -f5- | paste szeged.kr - | grep -v '	[XZ]	' | awk -f hunmorph_vs_szeged.awk | grep -v '<NO_KR>' | awk 'BEGIN {FS="\t"} {if ($$2 !~ /[0-9]/) {print}}' > szeged.kr-hunmorph
	cat szeged.kr-hunmorph | awk -f hunmorph_vs_szeged.stat.awk

top.errors:	szeged.kr-hunmorph
	cat szeged.kr-hunmorph | grep "0-1$$" | grep -v "TYPO\|UNKNOWN" | awk '{f[$$2 " " $$5 " " $$7]+=$$1} END{for(l in f){print f[l] "\t" l;}}' |  sort -n -r | cut -f2 | head -100 > top.errors 
