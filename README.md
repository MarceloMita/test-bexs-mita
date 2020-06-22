# BEXS TEST - Marcelo Mita

## Description

Bexs test solution from Marcelo Mita.

### Problem

The problem consists on find the best route in a graph read from a file that has
in each line a origin, a destination and a value. `origin,destination,value`.

### Assumptions

For the solution it has been assumed some requisites:

- The graph is oriented, that means each edge has a direction. In other words,
if a line says `a,b,10` it means that I can go from a to b with value 10, but
I can't go from b to a with the same value. If there is no `b,a,value` in the
file, I've assumed that `a` is not reachable from `b`.
- When creating a new edge for the graph, if the edge already exists, I'll just
override its value.  

### Justifications

- For the first assumption, I've chosen to consider the edges oriented because to
me it is possible to have one price to go from `a` to `b` and another to go back
from `b` to `a`, or even to have no way to go back.
- The second assumption, I've chosen to override because it is possible to just
update the value for the trip. If we've only created a new edge, it would be
possible that we could break the consistence of the graph or even use only the
cheapest value between two places, blocking the possibility of increasing the price.

### Solution

Its a well known problem of the Shortest path. As it is as single-source shortest
path problem for non-negative weighted directed edge graph, the solution was to
implement [Dijkstra's algorithm](https://en.wikipedia.org/wiki/Dijkstra%27s_algorithm).

## Project structure

```
root
  scripts
  src
  spec
```

- Inside root folder there are files to initialize project, install dependencies
and this README
- Inside `scripts` folder there are the files that are called from CLI to execute
tests, initialize server or run the script to execute application on the terminal.
- Inside `src` folder there are the files to execute all business logic needed.
- Inside `spec` folder there are the files that describes the tests.  

## Requisites

- Ruby installed

## Usage

Install gems:

```shell
bundle install
```

There is a CLI to interact with project. After installing the gems run:

```shell
./test_bexs {args}
```

The accepted arguments are:

```shell
create_routes {relative_path_to_input_file}
test
best_routes
server
```

### Creating input_file

To create a input_file, just run:

```shell
./test_bexs create_routes {relative_path_to_input_file}
```

### Running automated tests

```shell
./test_bexs test
```

### Running application to find best routes

```shell
./test_bexs best_routes
```

This will interact asking for a route, that must be inserted with format "ORIGIN-DESTINATION"

Example:

```shell
$ ./test_bexs best_routes
please enter the route: GRU-CDG
best route: GRU - BRC - SCL - ORL - CDG > 40
```

### Running server in order to expose a API

```shell
./test_bexs server
```

This will expose a REST API that have two endpoints:

#### [POST] /routes

It creates a new edge on the graph.

- Request:
```JSON
  Headers: {
    "Content-Type": "application-json"
  },
  BODY: {
    "from": "A",
    "to": "B",
    "value": 10
  }
```
- Response:
```JSON
  Status: 201,
  Body: ""
```

#### [GET] /best-route

It finds the best route between two vertices

- Request:
Can receive two query params formats:
  - `?from=ORG&to=DST`
  - `?route=ORG-DST`

- Response:
```JSON
  Status: 200,
  Body: "ORG - STP1 - STP2 - ... - DST > VALUE"
```
