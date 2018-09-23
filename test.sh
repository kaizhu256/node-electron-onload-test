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
    for uu in \
        https://www.amazon.com/gp/goldbox/ref=nav_cs_gb \
        https://www.netflix.com/ \
        https://www.ebay.com/rpp/moda-en \
        https://www.amazon.co.uk/gp/deals/ref=nav_cs_gb \
        https://www.etsy.com/c/accessories/hats-and-caps/winter-hats?ref=catnav-10855 \
        http://store.steampowered.com/search/?filter=topsellers \
        https://www.walmart.com/cp/televisions-video/1060825 \
        http://www.ikea.com/us/en/catalog/categories/departments/bathroom/ \
        https://www.bestbuy.com/site/home-appliances/refrigerators/abcat0901000.c?id=abcat0901000 \
        https://intl.target.com/c/clothing/-/N-5xtd3
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
