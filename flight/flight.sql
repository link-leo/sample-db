use master
go

create database flight
go

use flight
go

/****************
* CREATE SCHEMA *
****************/

create schema ref;
go

create table dbo.Airport (
	AirportId int identity not null
	,AirportCode varchar(5) not null
	,AirportName varchar(255) not null
	,Terminals int
	,City varchar(255) not null
	,[State] varchar(2) not null
);

create table ref.CrewRank (
	CrewRankId int identity not null
	,CrewRankName varchar(255) not null
);

create table dbo.Crew (
	CrewId int identity not null
	,CrewRankId int
	,FirstName varchar(255)
	,LastName varchar(255)
	,IsActive bit default 0 not null
);

create table ref.Model (
	ModelId int identity not null
	,ModelSerial varchar(50) not null
	,ModelName varchar(255) not null
);

create table dbo.Airplane (
	AirplaneId int identity not null
	,Serial uniqueidentifier not null
	,ModelId int
);

create table dbo.[Route] (
	RouteId int identity not null
	,OriginAirportId int not null
	,DestinationAirportId int not null
	,IsActive bit default 0 not null
);

create table dbo.Flight (
	FlightId int identity not null
	,RouteId int
	,AirplaneId int
	,TakeoffLocal datetime2
	,LandingLocal datetime2
);

create table dbo.FlightCrew (
	FlightCrewId int identity not null
	,FlightId int
	,CrewId int
	,CrewTypeId int
);
go

/***********************
* CREATE RELATIONSHIPS *
***********************/

alter table dbo.Airport
	add constraint pk_Airport_AirportId primary key clustered (AirportId);

alter table dbo.Airport
	add constraint uq_Airport_AirportCode unique (AirportCode);
go

alter table ref.CrewRank
	add constraint pk_CrewRank_CrewRankId primary key clustered (CrewRankId);

alter table ref.CrewRank
	add constraint uq_CrewRank_RankName unique (CrewRankName);
go

alter table dbo.Crew
	add constraint pk_Crew_CrewId primary key clustered (CrewId);

alter table dbo.Crew
	add constraint fk_Crew_CrewRankId foreign key (CrewRankId)
	references ref.CrewRank (CrewRankId)
	on delete set null
	on update cascade;
go

alter table ref.Model
	add constraint pk_Model_ModelId primary key clustered (ModelId);

alter table ref.Model
	add constraint uq_Model_ModelSerial unique (ModelSerial);

alter table ref.Model
	add constraint uq_Model_ModelName unique (ModelName);
go

alter table dbo.Airplane
	add constraint pk_Airplane_AirplaneId primary key clustered (AirplaneId);

alter table dbo.Airplane
	add constraint uq_Airplane_Serial unique (Serial);

alter table dbo.Airplane
	add constraint fk_Airplane_ModelId foreign key (ModelId)
	references ref.Model (ModelId)
	on delete set null
	on update cascade;
go

alter table dbo.[Route]
	add constraint pk_Route_RouteId primary key clustered (RouteId);

alter table dbo.[Route]
	add constraint uq_Route_NoDupRoutes unique (OriginAirportId,DestinationAirportId);

alter table dbo.[Route]
	add constraint fk_Route_OriginAirportId foreign key (OriginAirportId)
	references dbo.Airport (AirportId)
	on delete no action
	on update no action;

alter table dbo.[Route]
	add constraint fk_Route_DestinationAirportId foreign key (DestinationAirportId)
	references dbo.Airport (AirportId)
	on delete no action
	on update no action;
go

alter table dbo.Flight
	add constraint pk_Flight_FlightId primary key clustered (FlightId);

alter table dbo.Flight
	add constraint uq_Flight_Traffic unique (RouteId,TakeoffLocal,LandingLocal);

alter table dbo.Flight
	add constraint fk_Flight_RouteId foreign key (RouteId)
	references dbo.[Route] (RouteId)
	on delete set null
	on update cascade;

alter table dbo.Flight
	add constraint fk_Flight_AirplaneId foreign key (AirplaneId)
	references dbo.Airplane (AirplaneId)
	on delete set null
	on update cascade;
go

alter table dbo.FlightCrew
	add constraint pk_FlightCrew_FlightCrewId primary key clustered (FlightCrewId);

alter table dbo.FlightCrew
	add constraint uq_FlightCrew_FlightCrewType unique (FlightId,CrewTypeId);

alter table dbo.FlightCrew
	add constraint fk_FlightCrew_FlightId foreign key (FlightId)
	references dbo.Flight (FlightId)
	on delete set null
	on update cascade;

alter table dbo.FlightCrew
	add constraint fk_FlightCrew_CrewId foreign key (CrewId)
	references dbo.Crew (CrewId)
	on delete set null
	on update cascade;
go