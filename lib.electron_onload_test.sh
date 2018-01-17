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
        https://www.google.com \
        https://www.youtube.com \
        https://www.facebook.com \
        https://www.baidu.com \
        https://en.wikipedia.org/wiki/Main_Page \
        https://www.google.co.in \
        https://www.yahoo.com \
        https://www.reddit.com \
        http://www.qq.com \
        https://world.taobao.com
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
