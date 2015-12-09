
Execute bash commands (from my-docker-toolbox)

```
> dmcreate docker-koing

> dipull mashape/kong

> dipull mashape/cassandra

> dminit

> docker run -d -p 9042:9042 --name cassandra mashape/cassandra

> docker run -d -p 8000:8000 -p 8001:8001 --name kong --link cassandra:cassandra mashape/kong

> dps

> dopen 8001

// 20151209101703
// http://192.168.99.100:8001/

{
  "version": "0.5.4",
  "lua_version": "LuaJIT 2.1.0-alpha",
  "tagline": "Welcome to Kong",
  "hostname": "387dd20bfdf5",
  "plugins": {
      "enabled_in_cluster": {
		        },
    "available_on_server": [
        "ssl",
        "jwt",
        "acl",
        "cors",
        "oauth2",
        "tcp-log",
        "udp-log",
        "file-log",
        "hp-log",
        "key-auh",
        "hmac-auh",
        "asic-auh",
        "ip-resricion",
        "mashape-analyics",
        "reques-ransformer",
        "response-ransformer",
        "reques-size-limiing",
        "rae-limiing",
        "response-raelimiing"
        ]
      }
}
```

Check https://hub.docker.com/r/mashape/kong for more details

     
