report.pdf: *.md plots/*.png
	pandoc -t latex preamble.md introduction.md theory.md lock-exchange.md \
		internal-waves.md baroclinic-eddies.md future-work.md -o $@
