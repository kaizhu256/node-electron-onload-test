/*
electron.onload.test.js

this function will test the onload performance of the given url

# example usage 1:
mkdir -p node_modules
npm install electron-lite --electron-version=v1.1.1
url=https://www.google.com node_modules/.bin/electron electron.onload.test.js



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
        https://www.wikipedia.org \
        https://www.yahoo.com \
        https://www.reddit.com \
        https://www.google.co.in \
        http://www.qq.com \
        https://www.taobao.com \
        https://mail.google.com
    do
        for ii in 1 2 3 4 5 6 7 8 9 10
        do
            (url="$uu" node_modules/.bin/electron electron.onload.test.js 2>&1 | \
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
*/



/*jslint
    bitwise: true,
    browser: true,
    maxerr: 8,
    maxlen: 96,
    node: true,
    nomen: true,
    regexp: true,
    stupid: true
*/
(function () {
    'use strict';
    var local;
    local = {};
    // inject onload timer
    if (typeof window === 'object') {
        local.now = Date.now() - 1000;
        window.addEventListener('load', function () {
            // wait 1000 ms for async loaders to finish
            setTimeout(function () {
                console.error('onLoadTime ' + (Date.now() - local.now));
            }, 1000);
        });
        return;
    }
    // npm install electron-lite
    if (!require('fs').existsSync('node_modules/electron-lite') ||
            process.env.npm_config_electron_version) {
        require('child_process').spawnSync('mkdir', [
            '-p',
            'node_modules'
        ], { stdio: ['ignore', 1, 2] });
    }
    // wait for electron to init
    (process.versions.electron >= '0.35'
        ? require('electron').app
        : require('app')).once('ready', function () {
        // init local
        local = { frame: false, height: 768, width: 1024, x: 0, y: 0 };
        // init browserWindow;
        local.BrowserWindow = (process.versions.electron >= '0.35'
            ? require('electron').BrowserWindow
            : require('browser-window'));
        local.browserWindow = new local.BrowserWindow(local);
        // title
        local.browserWindow.on('page-title-updated', function (event, title) {
            if (event && title.indexOf('onLoadTime ') !== 0) {
                return;
            }
            local.tmp = JSON.parse(JSON.stringify(process.versions));
            local.tmp.arch = process.arch;
            local.tmp.onLoadTime = title.split(' ')[1];
            local.tmp.platform = process.platform;
            local.tmp.timestamp = new Date().toISOString();
            local.tmp.url = process.env.url;
            local.result = {};
            Object.keys(local.tmp).sort().forEach(function (key) {
                local.result[key] = local.tmp[key];
            });
            console.log();
            console.log(title + ' - ' + local.result.url);
            console.log(JSON.stringify(local.result));
            console.log();
            require('fs').writeFileSync('/tmp/electron.done', new Date().toISOString());
            process.exit(0);
        });
/* jslint-ignore-begin */
require('fs').writeFileSync('/tmp/electron.webview.html', '\
<style>\n\
body {\n\
  border: 1px solid black;\n\
  margin: 0;\n\
  padding: 0;\n\
}\n\
</style>\n\
<webview\n\
    id="webview1"\n\
    preload="' +  __filename + '"\n\
    src="' + process.env.url + '"\n\
    style="border: none;height: 100%;margin: 0;padding: 0;width: 100%;"\n\
>\n\
</webview>\n\
<script>\n\
(function () {\n\
    var local;\n\
    local = {};\n\
    local.webview1 = document.querySelector("#webview1");\n\
    local.webview1.addEventListener("console-message", function (event) {\n\
        if (event.message.indexOf("onLoadTime ") === 0) {\n\
            console.log(event.message);\n\
            document.title = event.message;\n\
        }\n\
    });\n\
}());\n\
</script>\n\
');
/* jslint-ignore-end */
        // open url
        local.url = 'file:///tmp/electron.webview.html';
        (local.browserWindow.loadURL || local.browserWindow.loadUrl).bind(
            local.browserWindow
        )(local.url, {
            userAgent: local.modeBrowserTest === 'scrape' &&
                'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 ' +
                '(KHTML, like Gecko) Chrome/53.0.2785.143 Safari/537.36'
        });
    });
}());
