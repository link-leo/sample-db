# flight
The `flight` database was designed to be a sandbox for practicing SQL queries. It simulates a small airline servicing various routes between airports and assigning crew to the airplane for each flight.

## Purpose
Provide an environment for SQL analysts/developers to experiment with queries using simulated data.

## Use
To set up and use the database, execute each `.sql` file in this repository on your **MS SQL Server** instance in alphabetical order to create the database and populate it with sample data.

## Documentation
To learn more about the database, access the [full database documentation](https://dbdocs.io/link/flight), including table/column descriptions and [Entity Relationship Diagram](https://dbdocs.io/link/flight?view=relationships).

## Files
- [flight_create.sql](https://git.leocorde.me/gitea/starlord/flight/src/branch/main/flight_create.sql) - Script to fully create the database schema (tables, relationships, views).
- [flight_data.sql](https://git.leocorde.me/gitea/starlord/flight/src/branch/main/flight_data.sql) - Script to load sample data into the database.
- [flight.dbml](https://git.leocorde.me/gitea/starlord/flight/src/branch/main/flight.dbml) - Configuration file to create documentation.
> See [dbml.org](https://www.dbml.org) for more information on the Database Markup Language.
