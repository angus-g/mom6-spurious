slides.pdf: slides.md
	pandoc -t beamer --latex-engine xelatex --filter pandoc-citeproc \
		../paper/bibliography.md $< -o $@
