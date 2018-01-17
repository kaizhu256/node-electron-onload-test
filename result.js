'use strict';
/*
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
 */
var arr0 = ["0.24.0","0.25.1","0.26.1","0.27.1","0.28.1","0.29.1","0.30.1","0.31.1","0.32.1","0.33.1","0.34.1","0.35.1","0.36.1","0.37.1","1.0.1","1.1.1","1.2.1","1.3.1","1.4.1","1.5.1","1.6.1","1.7.1"]
var dict = {};
window.data.forEach(function (element) {
    dict[element.url] = dict[element.url] || [];
    dict[element.url].push({
        meta: element,
        x: arr0.indexOf(element.electron),
        y: Number(element.onLoadTime)
    });
});
var series = [];
Object.keys(dict).sort().forEach(function (key, ii) {
    series.push({
        data: dict[key].map(function (element) {
            return {
                meta: element.meta,
                x: element.x + 0.25 + 0.05 * ii,
                y: element.y
            }
        }),
        marker: {
            radius: 2,
            //!! symbol: 'circle',
        },
        name: key
    });
});

Highcharts.chart('container', {
    chart: {
        type: 'scatter',
        zoomType: 'xy'
    },
    title: {
        text: 'onload-time for popular websites vs v8/electron version'
    },
    subtitle: {
        text: 'onload-time measured from electron startup to onload event (with 1000 ms offset)'
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
        tickInterval: 1000,
        title: {
            text: 'onload-time (ms)'
        }
        //!! type: 'logarithmic'
    },
    legend: {
        layout: 'vertical',
        align: 'right',
        //!! verticalAlign: 'center',
        //!! floating: true,
        //!! backgroundColor: (Highcharts.theme && Highcharts.theme.legendBackgroundColor) || '#FFFFFF',
        //!! borderWidth: 1
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
                pointFormat: 'v8 v{point.meta.v8}<br>' +
                    'electron v{point.meta.electron}<br>' +
                    '{point.y} ms'
                //!! formatter: function () {
                    //!! return (this.point.meta || '') + ' ' + this.y;
                //!! }

            }
        }
    },
    series: window.series
});


