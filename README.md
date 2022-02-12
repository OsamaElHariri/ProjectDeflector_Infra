# ProjectDeflector_Infra
Prod and local Infra setup


To run the whole project locally, make sure that the other servers are running, and that the client is connected to the internal network IP

## Scripts
The `compose_all_except.sh` script can be used to run all the services except a select few. This is useful in case you are currently working on a server and so will run it separately, but you still want all the other services running.

Run all services except the game server:
```
./scripts/compose_all_except.sh game_server
```

Run all services except the realtime and matchmaking servers:
```
./scripts/compose_all_except.sh realtime_server,matchmaking_server
```