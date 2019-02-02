# consul_play

Just playing with Consul.


## Install Dependencies

    `choco install -y consul`
    `choco install -y curl`
    `choco install -y jq`
    `choco install -y sed`


## Play

To start the server:

    `bin\start.cmd`

And from there you can set two to follow one:

    1. Go to http://localhost:8500/ui/local_machine/kv/notepad/two/
    2. Create a key called `follow`
    3. Set its value to `one`

Tell one to start:

    1. Go to http://localhost:8500/ui/local_machine/kv/notepad/one/state
    2. Create a key called `desired`
    3. Set the value to `running`

Then notepad instance one will figure out to start.

Once instance one is up, two will discover that it's changed and two will
also start.

Set one to `stopped` to have it eventually stop and two eventually follow.

## More

It works well with the [TICK monitoring suite](https://www.influxdata.com/time-series-platform/) and the [ELK log aggregator](https://www.elastic.co/webinars/introduction-elk-stack), both OSS easy and free at the low end and as complex and possibly expensive as you like on the high end. As an example, there's a [plugin for Telegraf, the T in TICK](https://www.consul.io/docs/guides/monitoring-telegraf.html). And there are plugins for dashboards like [Graphana](https://grafana.com/plugins/sbueringer-consul-datasource).
