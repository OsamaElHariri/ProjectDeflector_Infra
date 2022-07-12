# ProjectDeflector Infra

This repo holds the code to manage prod and local infra setups for the `Hit Bounce` mobile game.


## Mobile App

The mobile app, and a high level introduction to this project can be found in the [JsClientGame](https://github.com/OsamaElHariri/ProjectDeflector_JsClientGame) repo, which is intended to be the entry point to understanding this project.


## Backend Services

The servers that underly this project are written in Go. All the servers are run in a dev container to avoid needing to set up anything language specific. Dev containers allow VSCode to be used inside docker containers. These are all the servers that need to support the app:

- [Game Server](https://github.com/OsamaElHariri/ProjectDeflector_GameServer): handles game states and moves the games forward
- [Match Making Server](https://github.com/OsamaElHariri/ProjectDeflector_MatchMakingServer): handles queueing players and matching them together. Once matched, it sends them off to the Game Server
- [User Server](https://github.com/OsamaElHariri/ProjectDeflector_UserServer): handles user information and basic stats. This game does not store personal info so this server mainly keeps track of UUIDs and which color should the player be
- [Real Time Server](https://github.com/OsamaElHariri/ProjectDeflector_RealTimeServer): a websocket server

**Note:** All the services use a separate MongoDB instance as the database. 


## Why Microservices????

Just to be clear, I recommend starting projects as monoliths. There is no need to introduce a complex microservices architecture when starting out. That being said, this project uses microservices because I wanted to go deeper into microservices and get some hands on experience with some of the challenges that I read about.

## Local setup

The local setup needs you to have built the Go binaries for each server, _and_ these binaries need to be in a docker container. The way to do this for each server is the same and is described in their respective repos.

The reason I did this is so that I can have a quick way of spinning all the servers up from this repo. When I make some changes on a server, I build it and create it's docker image, then I can spin it up from this repo using the script described below.


## Scripts
The `compose_all_except.sh` script can be used to run all the services except a select few. This is useful in case I am currently working on a server and so will run it separately, but I still want all the other services running.

Run all services except the game server:
```
./scripts/compose_all_except.sh game_server
```

Run all services except the realtime and matchmaking servers:
```
./scripts/compose_all_except.sh realtime_server,matchmaking_server
```

This works by running a `docker-compose up` command under the hood


## Exposing Your Local Port

I like to test on a physical device. The way I have the app and the servers communicate is by allowing the phone to access my machine's port and the nginx load balancer running on port `8080`. First I run the servers by using the `compose_all_except.sh` script. Then I put my internal IP in the mobile app's code. On linux, I get my internal IP using the `hostname -I command`. There may be some firewall rules that do not allow this to happen, so make sure to open up port `8080` for this to work.


## Deploying to Prod

Deployment is basically an excerice in `ssh`. I have a server running. I simply copy over the resulting binary from each server using the `scp` command, then I `ssh` into the server and run the binaries.

First time setup included setting up the nginx load balancer on the server, setting up the domain, and setting up things like cert-bot and the secrets file that the servers need. Once that was done, I was just relying on `scp` to copy binaries from my machine to the server.

For the databases, the services point to a database hosted on [MongoAtlas](https://www.mongodb.com/atlas/database)