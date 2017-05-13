Elementrem Network Status Monitoring
============

The Elementrem network status monitor http://www.elementrem.info is a web-based application to monitor the health of the elementrem net through a group of nodes. To list your node, you must install the client-side information relay, a node module. Instructions given here work on Ubuntu (Mac OS X follow same instructions, but sudo may be unnecessary). Other platforms vary (please make sure that nodejs-legacy is also installed, otherwise some modules might fail).

## Prerequisite
* [Nodejs npm](https://nodejs.org/)    	
`curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -`  
`sudo apt-get install -y nodejs`  

* [PM 2](https://www.npmjs.com/package/pm2)		
`sudo npm install -g pm2`

## To list your node
elementrem gele or parity must be running with rpc enabled.
`gele --rpc`
the default port for rpc under gele is 7075

```
git clone https://github.com/elementrem/ele-net-intelligence-api
cd ele-net-intelligence-api
```
Then edit the app.json file in it to configure for your node:
```
[
  {
    "name"              : "node-app",
    "script"            : "app.js",
    "log_date_format"   : "YYYY-MM-DD HH:mm Z",
    "merge_logs"        : false,
    "watch"             : false,
    "max_restarts"      : 10,
    "exec_interpreter"  : "node",
    "exec_mode"         : "fork_mode",
    "env":
    {
      "NODE_ENV"        : "production", // tell the client we're in production environment
      "RPC_HOST"        : "localhost", // elementrem JSON-RPC host
      "RPC_PORT"        : "7075", // elementrem JSON-RPC port
      "LISTENING_PORT"  : "30707", // elementrem  listening port (only used for display)
      "INSTANCE_NAME"   : "", // whatever you wish to name your node
      "CONTACT_DETAILS" : "", // add your contact details here if you wish (email/skype)
      "WS_SERVER"       : "http://www.elementrem.info/", 
      "WS_SECRET"       : "j39skdlq92k",
      "VERBOSITY"       : 2 // Set the verbosity (0 = silent, 1 = error, warn, 2 = error, warn, info, success, 3 = all logs)
    }
  }
]
```

Finally run the process with:
```
npm install
pm2 start app.json
```
***From now on, your node was registered on http://www.elementrem.info***

Several commands are available:
- `pm2 list` to display the process status;
- `pm2 logs` to display logs;
- `pm2 gracefulReload node-app` for a soft reload;
- `pm2 stop node-app` to stop the app;
- `pm2 kill` to kill the daemon.

