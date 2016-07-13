
ONTS = DOID HP UBERON GO CL
ALL_PROPER = $(patsubst %,%-proper,$(ONTS))
ALL_TOKENS = $(patsubst %,%-tokens,$(ONTS))

all: all_tokens proper_est.txt report.txt
#all_proper: $(ALL_PROPER) proper.txt
all_tokens: $(ALL_TOKENS) tokens.txt

#%-labels:
#	blip-findall -r $* "class(_,N)" -select N > $@.tmp && mv $@.tmp $@

%-terms:
	blip-findall -r $* "entity_label_scope(C,L,S),class(C,N)" -no_pred -select "x(C,L,S,N)" > $@.tmp && mv $@.tmp $@
.PRECIOUS: %-terms

#%-proper: %-labels
#	./find-capitalized.pl $< > $@.tmp && sort -u $@.tmp > $@

%-tokens: %-terms
	./tokenize.pl $< > $@.tmp && mv $@.tmp  $@

#proper.txt: $(ALL_PROPER)
#	sort -u $^ > $@

tokens.txt: $(ALL_TOKENS)
	sort -u $^ > $@
.PRECIOUS: tokens.txt

proper_est.txt: tokens.txt blacklisted.pro
	blip-findall -i $< -i blacklisted.pro -consult extract_proper.pro proper/2 -no_pred > $@.tmp && sort -u $@.tmp > $@
.PRECIOUS: proper_est.txt

check.pl: proper_est.txt
	./make-perl-checker.pl $< > $@.tmp && mv $@.tmp $@

blacklisted.pro: curated_negative.txt curated_ambiguous.txt
	perl -npe 'chomp;s@\s.*@@;s@$$@\n@' $^ | tbl2p -p blacklisted > $@

report.txt: tokens.txt check.pl
	perl -n check.pl $< >& $@.tmp && mv $@.tmp $@
