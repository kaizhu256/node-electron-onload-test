# example usage 2:
printf "" > "$HOME/electron.log"
rm -f /tmp/electron.done
for vv in \
    v0.24.0 \
    v0.25.1 \
    v0.26.1 \
    v0.27.1 \
    v0.28.1 \
    v0.29.1 \
    v0.30.1 \
    v0.31.1 \
    v0.32.1 \
    v0.33.1 \
    v0.34.1 \
    v0.35.1 \
    v0.36.1 \
    v0.37.1 \
    v1.0.1 \
    v1.1.1 \
    v1.2.1 \
    v1.3.1 \
    v1.4.1 \
    v1.5.1 \
    v1.6.1 \
    v1.7.1
do
    mkdir -p node_modules
    npm install electron-lite --electron-version="$vv"
# https://en.wikipedia.org/wiki/List_of_most_popular_websites
URL_LIST='
https://www.google.com
https://www.youtube.com
https://www.facebook.com
https://www.baidu.com
https://en.wikipedia.org/wiki/Main_Page
https://www.google.co.in
https://www.yahoo.com
https://www.reddit.com
http://www.qq.com
https://world.taobao.com
'
# https://www.alexa.com/topsites/category/Top/Shopping
URL_LIST='
https://www.amazon.com/gp/goldbox/ref=nav_cs_gb
https://www.netflix.com/
https://www.ebay.com/rpp/moda-en
https://www.amazon.co.uk/gp/deals/ref=nav_cs_gb
https://www.etsy.com/c/accessories/hats-and-caps/winter-hats?ref=catnav-10855
http://store.steampowered.com/search/?filter=topsellers
https://www.walmart.com/cp/televisions-video/1060825
http://www.ikea.com/us/en/catalog/categories/departments/bathroom/
https://www.bestbuy.com/site/home-appliances/refrigerators/abcat0901000.c?id=abcat0901000
https://intl.target.com/c/clothing/-/N-5xtd3
'
# https://www.creativebloq.com/web-design/examples-of-javascript-1233964
URL_LIST='
http://www.histography.io/
http://www.filippobello.com/
http://thestlbrowns.com/
http://legworkstudio.com/
http://codeconf.com/
http://ibm.com/design
http://www.masitupungato.com/
http://khan.github.io/tota11y
http://knowlupus.org/
http://sbs.com.au/theboat
http://run4tiger.com/
http://debbiemillman.com/designmatters
http://wrapgenius.me/
http://thelocalpalate.com/
http://mikekus.com/
http://multeor.com/
http://hereistoday.com/
http://www.jacktorrancetrip.com/
http://www.mapstd.com/
http://www.adityaravishankar.com/projects/games/command-and-conquer
http://www.peanutgalleryfilms.com/
'
# https://medium.com/@coderacademy/32-sites-built-with-reactjs-172e3a4bed81
URL_LIST='
https://www.adroll.com/product
https://www.airbnb.com/s/homes?refinement_paths%5B%5D=%2Fhomes
https://asana.com/product
https://www.atlassian.com/software/jira
https://www.cloudflare.com/cdn/
https://www.dropbox.com/business
http://www.bbc.com/
http://bleacherreport.com/nba
https://www.facebook.com/login/
https://flipboard.com/
https://imgur.com/new/time
https://www.instagram.com/?hl=en
https://www.kissmetrics.com/product/
https://www.khanacademy.org/math/early-math/cc-early-math-counting-topic
https://mattermark.com/discovery/
https://www.netflix.com/
https://www.okcupid.com/
https://www.paypal.com/vn/webapps/mpp/pay-on-ebay
https://www.periscope.tv/channel/featured-broadcasts
https://podio.com/site/en/tour
https://postmates.com/
https://www.producthunt.com/topics/tech
https://www.reddit.com/new/
https://www.salesforce.com/ap/solutions/by-role/salesforce-for-sales/
https://www.scribd.com/
https://www.squarespace.com/templates
https://www.tesla.com/models
https://www.uber.com/en-US/fare-estimate/
https://venmo.com/about/product/
https://web.whatsapp.com/
https://www.wolframalpha.com/examples/math/
https://www.zendesk.com/omnichannel/
'
    for uu in $URL_LIST
    do
        for ii in 1 2 3 4 5 6 7 8 9 10
        do
            (url="$uu" node_modules/.bin/electron lib.electron_onload_test.js 2>&1 | \
                tee -a "$HOME/electron.log") &
            for ii in \
                 1  2  3  4  5  6  7  8  9 10 \
                11 12 13 14 15 16 17 18 19 20 \
                21 22 23 24 25 26 27 28 29 30
            do
                sleep 1
                if [ -f /tmp/electron.done ]
                then
                    break
                fi
            done
            rm -f /tmp/electron.done
            killall Electron electron 2>/dev/null
            sleep 1
        done
    done
done
