# JobProcessor
![job processor logo](https://hopeful-bose-df991f.netlify.com/plan.png)
> An HTTP job processing service.

[![CircleCI](https://circleci.com/gh/lbighetti/job_processor.svg?style=svg&circle-token=92be9252e9b7cf812afa5ecd9110a8933661ac95)](https://circleci.com/gh/lbighetti/job_processor)[![codecov](https://codecov.io/gh/lbighetti/job_processor/branch/master/graph/badge.svg)](https://codecov.io/gh/lbighetti/job_processor)

## Overview

Here the definition of a job is a collection of tasks, where each task has a name and a shell command. Tasks may depend on other tasks and require that those are executed beforehand. This service takes care of sorting the tasks to create a proper execution order.

### Example

```json
{
   "tasks":[
      {
         "name":"task-1",
         "command":"touch /tmp/file1"
      },
      {
         "name":"task-2",
         "command":"cat /tmp/file1",
         "requires":[
            "task-3"
         ]
      },
      {
         "name":"task-3",
         "command":"echo 'Hello World!' > /tmp/file1",
         "requires":[
            "task-1"
         ]
      },
      {
         "name":"task-4",
         "command":"rm /tmp/file1",
         "requires":[
            "task-2",
            "task-3"
         ]
      }
   ]
}
```

### Responses

The server can respond in two format: JSON and bash script in the form of text.

#### JSON

The above example will be processed to this response:

```json
[
   {
      "name":"task-1",
      "command":"touch /tmp/file1"
   },
   {
      "name":"task-3",
      "command":"echo 'Hello World!' > /tmp/file1"
   },
   {
      "name":"task-2",
      "command":"cat /tmp/file1"
   },
   {
      "name":"task-4",
      "command":"rm /tmp/file1"
   }
]
```

#### Bash Script

The bash script response will be of type text, and will look like this:

```bash
#!/usr/bin/env bash

touch /tmp/file1
echo "Hello World!" > /tmp/file1
cat /tmp/file1
rm /tmp/file1
```

This way, it's possible to run it directly like so:

```bash
$ curl -d @mytasks.json -X POST -H 'Accept: text/plain' -H "Content-Type:application/json" http://localhost:4000/process_job | bash
```

## Development

Requirements

- elixir 1.8
- erlang 21.2

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server`

### API documentation

- You can open Swagger API documentation at `http://localhost:4000/api/swagger`.  
- You can re-generate or update it by running `mix phx.swagger.generate`.  

### Tests & Coverage

- Run tests with `mix test`
- Run coverage with [`mix coveralls`](https://hexdocs.pm/excoveralls/Mix.Tasks.Coveralls.html)
- [Codecov](https://codecov.io/gh/lbighetti/job_processor) is being used as a coverage webpage.

### Static Code Analysis

Credo is a static code analysis tool for the Elixir language with a focus on teaching and code consistency.

- Run credo with `mix credo`

### Dialyzer

Dialyzer can analyze code with typespec to find type inconsistencies and possible bugs.

* Run dialyzer with `mix dialyzer`

Be aware this takes a while to run for the first time. Runs after the first will be a lot faster.

### Documentation

You can update or re-generate this documentation with

* `mix docs && open doc/index.html`


