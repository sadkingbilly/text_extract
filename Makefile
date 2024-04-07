# Directories for input PDFs (expected to exist), temporary, and output files.
PDFS := pdfs
TMPS := tmps
TXTS := txts

# Language to use with tesseract (Lithuanian).
TESS_LANG := lit

$(TMPS):
	mkdir -p $(TMPS)

$(TXTS):
	mkdir -p $(TXTS)

# "pdftotext" extracts the existing text annotations from PDF files (if any).
#
$(TXTS)/%.pdftotext.txt: $(PDFS)/%.pdf | $(TXTS)
	pdftotext $< $@

# Tesseract.
#
$(TXTS)/%.tesseract.txt: $(PDFS)/%.pdf | $(TXTS) $(TMPS)
	tmpdir="$(TMPS)/$(basename $(<F)).tesseract"; \
	mkdir -p $${tmpdir}; \
	pdfimages -j $< $${tmpdir}/page; \
	for jpg in $${tmpdir}/*.jpg; \
	do \
	  tesseract -l $(TESS_LANG) $${jpg} $${tmpdir}/$$(basename $${jpg}); \
	done; \
	cat $${tmpdir}/*.txt > $@

# AWS Textract.
#
$(TXTS)/%.textract.txt: $(PDFS)/%.pdf | $(TXTS) $(TMPS)
	tmpdir="$(TMPS)/$(basename $(<F)).textract"; \
	mkdir -p $${tmpdir}; \
	pdfimages -j $< $${tmpdir}/page; \
	for jpg in $${tmpdir}/*.jpg; \
	do \
 	  amazon-textract \
      	    --input-document "$${jpg}" \
            --overlay-output-folder "$${tmpdir}" \
            --overlay LINE \
            --pretty-print LINES \
	    | ansi2txt > $${tmpdir}/$$(basename $${jpg}).txt; \
	done; \
	cat $${tmpdir}/*.txt > $@

targets = $(addprefix $(TXTS)/,$(addsuffix .$(1).txt,$(basename $(notdir $(wildcard $(PDFS)/*.pdf)))))

.PHONY: all-pdftotext all-tesseract all-textract all
all-pdftotext: $(call targets,pdftotext)
all-tesseract: $(call targets,tesseract)
all-textract: $(call targets,textract)
all: all-pdftotext all-tesseract all-textract
