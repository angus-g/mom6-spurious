report.pdf: *.md plots/*.png
	pandoc --filter pandoc-citeproc -t latex --latex-engine xelatex -o $@ \
		preamble.md bibliography.md introduction.md theory.md lock-exchange.md \
		internal-waves.md baroclinic-eddies.md future-work.md
