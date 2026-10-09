https://github.com/web4hub/web4-browser.git
cd web4-browser
git checkout feat/product-json-schema
# fix static/marketplace.html
git add static/marketplace.html
git commit -m "Fix duplicate tradeToken id"
git push origin feat/product-json-schema
gh pr merge 6 --merge
