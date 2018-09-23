":" /*
rm -f "$HOME/electron.log"
rm -f /tmp/electron.done
for vv in \
    v0.24 \
    v0.25 \
    v0.26 \
    v0.27 \
    v0.28 \
    v0.29 \
    v0.30 \
    v0.31 \
    v0.32 \
    v0.33 \
    v0.34 \
    v0.35 \
    v0.36 \
    v0.37 \
    v1.0 \
    v1.1 \
    v1.2 \
    v1.3 \
    v1.4 \
    v1.5 \
    v1.6 \
    v1.7 \
    v1.8 \
    v2.0 \
    v3.0
do
    mkdir -p node_modules
    npm install kaizhu256/electron-lite#alpha --electron-version="$vv"
URL_LIST="
https://kaizhu256.github.io/sql.js/GUI/deoptimize.index.html
https://kaizhu256.github.io/swagger-ui/dist/index.html
"
    for uu in $URL_LIST
    do
        for ii in 1 2 3 4 5 6 7 8 9 10
        do
            (url="$uu" node_modules/.bin/electron lib.electron_onload_test.sh 2>&1 | \
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
":" */



":" //'
;
// <script>
/* jslint-utility2 */
/*jslint
    bitwise: true,
    browser: true,
    maxerr: 4,
    maxlen: 100,
    node: true,
    nomen: true,
    regexp: true,
    stupid: true
*/
(function () {
    "use strict";
    var local;
    local = {};
    // inject onload timer
    if (typeof window === "object") {
        // compensate for 1000 ms wait-offset after onload to take into account cpu-heavy renders
        local.now = Date.now() - 100;
        window.addEventListener("load", function () {
            // wait 1000 ms for async loaders to finish
            setTimeout(function () {
                console.error("onLoadTime " + (Date.now() - local.now));
            }, 100);
        });
        return;
    }
    /* validateLineSortedReset */
    if (!process.versions.electron) {
        return;
    }
    // npm install electron-lite
    if (!require("fs").existsSync("node_modules/electron-lite") ||
            process.env.npm_config_electron_version) {
        require("child_process").spawnSync("mkdir", [
            "-p",
            "node_modules"
        ], { stdio: ["ignore", 1, 2] });
    }
    // wait for electron to init
    (process.versions.electron >= "0.35"
        ? require("electron").app
        : require("app")).once("ready", function () {
        // init local
        local = { frame: false, height: 768, width: 1024, x: 0, y: 0 };
        // init browserWindow;
        local.BrowserWindow = (process.versions.electron >= "0.35"
            ? require("electron").BrowserWindow
            : require("browser-window"));
        local.browserWindow = new local.BrowserWindow(local);
        // title
        local.browserWindow.on("page-title-updated", function (event, title) {
            if (event && title.indexOf("onLoadTime ") !== 0) {
                return;
            }
            local.tmp = JSON.parse(JSON.stringify(process.versions));
            local.tmp.arch = process.arch;
            local.tmp.onLoadTime = title.split(" ")[1];
            local.tmp.platform = process.platform;
            local.tmp.timestamp = new Date().toISOString();
            local.tmp.url = process.env.url;
            local.result = {};
            Object.keys(local.tmp).sort().forEach(function (key) {
                local.result[key] = local.tmp[key];
            });
            console.log();
            console.log(title + " - " + local.result.url);
            console.log(JSON.stringify(local.result));
            console.log();
            require("fs").writeFileSync("/tmp/electron.done", new Date().toISOString());
            process.exit(0);
        });
/* jslint-ignore-begin */
require("fs").writeFileSync("/tmp/electron.webview.html", "\
<style>\n\
body {\n\
  border: 1px solid black;\n\
  margin: 0;\n\
  padding: 0;\n\
}\n\
</style>\n\
<webview\n\
    id=\"webview1\"\n\
    preload=\"" +  __filename + "\"\n\
    src=\"" + process.env.url + "\"\n\
    style=\"border: none;height: 100%;margin: 0;padding: 0;width: 100%;\"\n\
>\n\
</webview>\n\
<script>\n\
(function () {\n\
    var local;\n\
    local = {};\n\
    local.webview1 = document.querySelector(\"#webview1\");\n\
    local.webview1.addEventListener(\"console-message\", function (event) {\n\
        if (event.message.indexOf(\"onLoadTime \") === 0) {\n\
            console.log(event.message);\n\
            document.title = event.message;\n\
        }\n\
    });\n\
}());\n\
<\/script>\n\
");
/* jslint-ignore-end */
        /* validateLineSortedReset */
        // open url
        local.url = "file:///tmp/electron.webview.html";
        (local.browserWindow.loadURL || local.browserWindow.loadUrl).bind(
            local.browserWindow
        )(local.url, {
            userAgent: local.modeBrowserTest === "scrape" &&
                "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 " +
                "(KHTML, like Gecko) Chrome/53.0.2785.143 Safari/537.36"
        });
    });
}());
// </script>
":" //'
