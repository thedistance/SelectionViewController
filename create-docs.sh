jazzy \
--output "docs/JazzyDocs" \
--author "Josh Campion @ The Distance" \
--author_url "https://github.com/thedistance" \
--github_url "https://github.com/thedistance/SelectionViewController"

headerdoc2html -o "docs/headerdocs" "SelectionViewController"

gatherheaderdoc "docs/headerdocs"