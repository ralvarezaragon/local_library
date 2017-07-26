#!/usr/bin/env python
from prometheus_client import start_http_server, Summary, Gauge
import urllib2
import ssl
import datetime
from time import sleep

def open_csv():
    ctx = ssl.create_default_context()
    ctx.check_hostname = False
    ctx.verify_mode = ssl.CERT_NONE
    url = "https://10.0.3.1/haproxy?stats;csv"
    response = urllib2.urlopen(url, context=ctx)
    data = response.read()
    return data


def prepare_csv_data():
    csv_out = open_csv()
    data_raw = csv_out.split("\n")
    data = [x for x in data_raw if
                ("hopper" in x or "stats" in x or "frank" in x) and ("FRONTEND" not in x and "BACKEND" not in x)]
    return data


def parse_status(par):
    switcher = {
        "UP": 1,
        "DOWN": 0,
        "OPEN": 1,
    }
    return switcher.get(par, 0)


def get_metric(l_metric, metric_req, gauge_obj):
    l_metric_length = len(l_metric)
    a_metric = [None] * l_metric_length
    for i in range(l_metric_length):
        a_metric[i] = l_metric[i].split(",")
        if metric_req == "status":
            metric_value = parse_status(a_metric[i][17])
        elif metric_req == "curr_session":
            metric_value = a_metric[i][33]
        else:
            metric_value = 0
        gauge_obj.labels(a_metric[i][1]).set(metric_value)

    return gauge_obj


if __name__ == '__main__':
    # Create the metric object
    g_status = Gauge("haproxy_node_status", "haproxy node status", ['ins'])
    g_curr_session = Gauge("haproxy_node_curr_session_rate", "haproxy node current session rate", ['ins'])
    # Start up the server to expose the metrics.
    start_http_server(8000)
    # Generate some requests.
    while True:
        # Add metric_time for script output
        time = datetime.datetime.time(datetime.datetime.now())
        # open csv for metric extraction
        csv_data = prepare_csv_data()
        get_metric(csv_data, "status", g_status)
        get_metric(csv_data, "curr_session", g_curr_session)
        print "{0} haproxy_node_status:localhost:8000".format(time)
        print "{0} haproxy_node_curr_session_rate:localhost:8000".format(time)
        sleep(5)
