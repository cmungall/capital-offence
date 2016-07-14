
##ONTS = DOID HP UBERON GO CL
ONTS = DOID HP UBERON GO

ALL_PROPER = $(patsubst %,%-proper,$(ONTS))
ALL_TOKENS = $(patsubst %,%-tokens,$(ONTS))

all: all_tokens proper_est.txt report.txt report-upper.txt
#all_proper: $(ALL_PROPER) proper.txt
all_tokens: $(ALL_TOKENS) tokens.txt

#%-labels:
#	blip-findall -r $* "class(_,N)" -select N > $@.tmp && mv $@.tmp $@

%-terms:
	blip-findall -r $* "entity_label_scope(C,L,S),class(C,N),\+entity_synonym_type(C,L,'ABBREVIATION')" -no_pred -select "x(C,L,S,N)" > $@.tmp && mv $@.tmp $@
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

blacklisted.pro: curated_negative.txt curated_ambiguous.txt
	perl -npe 'chomp;s@\s.*@@;s@$$@\n@' $^ | grep -v ^\# | tbl2p -p blacklisted > $@


## use rules to infer proper nouns and other words that should be capitalized.
## Exclude:
##  - words we know should never be capitalized (curated_negative)
##  - words that we know are optionally capitalized (curated_ambiguous)
proper_est.txt: tokens.txt blacklisted.pro
	blip-findall -i $< -i blacklisted.pro -consult extract_proper.pro proper/2 -no_pred > $@.tmp && sort -u $@.tmp > $@
.PRECIOUS: proper_est.txt

# report on any lowercase labels that should be capitalized.
# E.g. if an ontology has a label "purkinje cell"
check.pl: proper_est.txt
	./make-perl-checker.pl $< > $@.tmp && mv $@.tmp $@

## TODO: report any inappropriately capitalized
## NOTE: many of these fall out of the earlier process: they are used to seed the proper nouns list;
##       later these are the cause of false positives
check-upper.pl: curated_negative.txt
	./make-perl-checker-upper.pl $< > $@.tmp && mv $@.tmp $@


report.txt: tokens.txt check.pl
	perl -n check.pl $< >& $@.tmp && mv $@.tmp $@
.PRECIOUS: report.txt

report-upper.txt: tokens.txt check-upper.pl
	perl -n check-upper.pl $< >& $@.tmp && mv $@.tmp $@
.PRECIOUS: report.txt


failwords.txt: report.txt
	perl -ne 'print "$$1\n" if m@\((\S+)\)@' report.txt | sort -u > $@
