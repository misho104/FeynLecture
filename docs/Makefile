title           = FeynLecture
md_dir          = src_md
template       := _src/Lecture.template
template_local := _src/Lecture.template.local # template without remote assets

sources = $(notdir $(wildcard $(md_dir)/*.md))
targets = $(addsuffix .html,$(basename $(sources)))

.PHONY: all hot cold hotlocal coldlocal clean

all: $(targets)

mode := hot
hot:        mode:=hot
cold:       mode:=cold
hotlocal:   mode:=hot  template:=$(template_local)
coldlocal:  mode:=cold template:=$(template_local)

hot:       all
cold:      all
hotlocal:  all
coldlocal: all

clean:
	@rm -f $(targets)

%.html: $(md_dir)/%.md $(template)
	@TEMPLATE=$(template) SRC="$<" make -B $*.html-$(mode)
%.html-hot:
	sed -e "s!%TITLE%!$(title) $*!" -e "s!%SOURCE%!{sourceUrl: \"${SRC}\"}!" ${TEMPLATE} > $*.html
%.html-cold:
	sed -e "s!%TITLE%!$(title) $*!" -e "/<textarea id=\"source\">/r ${SRC}" -e "s/%SOURCE%//" ${TEMPLATE} > $*.html

.PHONY: archive
archive: slides.zip feynlecture_a.tar.gz feynlecture_a.zip
slides.zip: clean cold
	zip slides.zip -r $(targets) assets remote index.html

material_a = Lecture* models phi* readme.md MathematicaBasic.pdf MathematicaBasic.txt
feynlecture_a.tar.gz:
	(cd .. && tar czvf docs/$@ $(material_a))
feynlecture_a.zip:
	(cd .. && zip -r docs/$@ $(material_a))

