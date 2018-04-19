#!/bin/bash
/usr/bin/pm2 start /netstats/app.json && /usr/bin/pm2 logs node-app
