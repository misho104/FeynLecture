title           = FeynLecture
md_dir          = src
template       := src/Lecture.template
template_local := src/Lecture.template.local # template without remote assets

sources = $(notdir $(wildcard $(md_dir)/*.md))
targets = $(addsuffix .html,$(basename $(sources)))

.PHONY: all hot local hotlocal clean

all: $(targets)

mode := cold
hot:      mode:=hot
hotlocal: mode:=hot
local:    template:=$(template_local)
hotlocal: template:=$(template_local)

hot:      all
local:    all
hotlocal: all

clean:
	@rm -f $(targets) $(targets_for_chrome)

%.html: $(md_dir)/%.md $(template)
	@TEMPLATE=$(template) SRC="$<" make -B $*.html-$(mode)
%.html-hot:
	sed -e "s!%TITLE%!$(title) $*!" -e "s!%SOURCE%!{sourceUrl: \"${SRC}\"}!" ${TEMPLATE} > $*.html
%.html-cold:
	sed -e "s!%TITLE%!$(title) $*!" -e "/<textarea id=\"source\">/r ${SRC}" -e "s/%SOURCE%//" ${TEMPLATE} > $*.html

.PHONY: archive
archive: slides.zip
slides.zip: clean local
	zip slides.zip -r $(targets) assets remote index.html

