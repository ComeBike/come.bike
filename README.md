# ComeBike

An Open Source Community Site for local bicycling events

[![CircleCI](https://circleci.com/gh/ComeBike/come.bike.svg?style=svg)](https://circleci.com/gh/ComeBike/come.bike) [![Coverage Status](https://coveralls.io/repos/github/ComeBike/come.bike/badge.svg?branch=master)](https://coveralls.io/github/ComeBike/come.bike?branch=master)     


## Standing up a local dev environment    

If you would like to contribute to this project please feel free to follow the directions below to get a working local development environment.    

The following directions assume you are on a unix system. Windows users will need to look up how to install the required software respectively.    

- Fork and clone the Repo
- CD in to the root of the project `cd [YOUR PROJECT FILE PATH]`
- Pull down all the Mix packages `mix deps.get`
- Pull down all the Node packages `cd assets && yarn`
- CD back into the root of the project `cd ../`
- Create the local database `mix ecto.create`
- Run the db migrations `mix ecto.migrate`
- Run the seed data to build the test user `mix run priv/repo/seeds.exs` (this will create a user of 'test@test.com' with a password of 'password')
- Start the server `mix phx.server`
- Visit `http://localhost:4000`    

Software requirements.    
- Elixir ~> 1.4 (1.6.0-rc0 recommended)
- Erlang ~> 19.0 (20.2 recommended)
- Postgresql 9.6


Its recommended you use a version manager to install the required software such as `asdf https://github.com/asdf-vm/asdf`

## Contributing code

All code merged into the master branch will need to be done so from a PR.
All PRs require passing tests and no loss in code test coverage.
If possible it would be nice to have no less than 2 Peers review the PRs before merged into master.


## Contributing Ideas

We welcome feed back in all forms. Please feel free to write an issue for the following.
- Bugs: If you run into a bug please the issue respectively
- Feature requests: If you like to see something on come.bike tag the issue respectively

Note: Not all issues submitted are guaranteed to be addressed and this site does not provide any warranty for any of its defects. 
