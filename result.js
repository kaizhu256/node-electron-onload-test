/*jslint
    browser: true,
    maxlen: 100,
    node: true
*/
'use strict';
/*
https://en.wikipedia.org/wiki/List_of_most_popular_websites
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
 */
var arr0, dict, mean, options, series, tmp, variance;
window['debug_inline'.replace('_i', 'I')] = function (arg) {
/*
 * this function will both print the arg to stderr and return it
 */
    // debug arguments
    console.error('\n\n\ndebug_inline'.replace('_i', 'I'));
    console.error.apply(console, arguments);
    console.error();
    // return arg for inspection
    return arg;
};
arr0 = [
    "0.24.0",
    "0.25.1",
    "0.26.1",
    "0.27.1",
    "0.28.1",
    "0.29.1",
    "0.30.1",
    "0.31.1",
    "0.32.1",
    "0.33.1",
    "0.34.1",
    "0.35.1",
    "0.36.1",
    "0.37.1",
    "1.0.1",
    "1.1.1",
    "1.2.1",
    "1.3.1",
    "1.4.1",
    "1.5.1",
    "1.6.1",
    "1.7.1"
];
dict = {};
window.data.forEach(function (element) {
    dict[element.url] = dict[element.url] || [];
    dict[element.url].push({
        meta: element,
        x: arr0.indexOf(element.electron),
        y: Number(element.onLoadTime)
    });
});
series = [];
Object.keys(dict).sort().forEach(function (key, ii) {
    series.push({
        data: dict[key]
            // calculate mean
            .map(function (element, jj, list) {
                if (jj === 0) {
                    mean = 0;
                }
                mean += element.y;
                if (jj + 1 === list.length) {
                    mean = mean / list.length;
                }
                return element;
            })
            // calculate variance
            .map(function (element, jj, list) {
                if (jj === 0) {
                    variance = 0;
                }
                variance += (element.y - mean) * (element.y - mean);
                if (jj + 1 === list.length) {
                    variance = variance / (list.length - 1);
                }
                return element;
            })
            // filter outlier variance
            .filter(function (element) {
                return (element.y - mean) * (element.y - mean) < 4 * variance;
            })
            .map(function (element) {
                return {
                    meta: element.meta,
                    x: element.x + 0.25 + 0.05 * ii,
                    y: element.y
                };
            }),
        marker: {
            radius: 2
        },
        name: key.split('/')[2]
    });
});

// plot with options
options = {
    chart: {
        type: 'scatter',
        zoomType: 'xy'
    },
    legend: {
        align: 'left',
        borderWidth: 1,
        layout: 'vertical',
        verticalAlign: 'top',
        y: 50
    },
    plotOptions: {
        scatter: {
            marker: {
                radius: 5,
                states: {
                    hover: {
                        enabled: true,
                        lineColor: 'rgb(100,100,100)'
                    }
                }
            },
            states: {
                hover: {
                    marker: {
                        enabled: false
                    }
                }
            },
            tooltip: {
                headerFormat: '<b>{series.name}</b><br>',
                pointFormat: '<b>onload-time {point.y} ms</b><br>' +
                    'url {point.meta.url}<br>' +
                    'v8 v{point.meta.v8}<br>' +
                    'electron v{point.meta.electron}<br>'
            }
        }
    },
    subtitle: {
        text: '(with outliers >= 2 standard-deviations removed)'
    },
    title: {
        text: 'onload-time for popular websites vs v8/electron version'
    },
    xAxis: {
        gridLineWidth: 1,
        tickInterval: 1,
        labels: {
            enabled: false
        },
        title: {
            enabled: true,
            text: 'v8/electron version'
        },
        startOnTick: true,
        endOnTick: true,
        showLastLabel: true
    },
    yAxis: {
        title: {
            text: 'onload-time (ms)'
        }
    }
};
tmp = JSON.parse(JSON.stringify(options));
tmp = document.createElement('div');
tmp.id = 'container';
tmp.style.height = '512px';
tmp.style.width = '1024px';
document.body.appendChild(tmp);
tmp = JSON.parse(JSON.stringify(options));
tmp.series = series;
window.Highcharts.chart('container', tmp);
series.forEach(function (element, ii) {
    tmp = document.createElement('div');
    tmp.id = 'container' + ii;
    tmp.style.height = '512px';
    tmp.style.width = '1024px';
    document.body.appendChild(tmp);
    tmp = JSON.parse(JSON.stringify(options));
    tmp.series = [element];
    window.Highcharts.chart('container' + ii, tmp);
});

// raw data
tmp = document.createElement('pre');
tmp.style.background = '#ddd';
tmp.style.height = '512px';
tmp.style.overflow = 'auto';
tmp.style.width = '1024px';
tmp.textContent = 'raw data:\n' + JSON.stringify(window.data).replace((/\},/g), '},\n');
document.body.appendChild(tmp);
