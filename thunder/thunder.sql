use master
go

create database thunder
go

use thunder
go

/****************
* CREATE SCHEMA *
****************/

create schema hist;
go

create schema ref;
go

create table dbo.Member (
	MemberId int identity not null
	,RegistrationDate date not null
	,constraint pk_Member_MemberId primary key clustered (MemberId)
	,ValidFrom datetime2 generated always as row start not null
	,ValidTo datetime2 generated always as row end not null
	,period for system_time (ValidFrom,ValidTo)
) with (system_versioning = on (history_table = hist.Member));
go

create table dbo.MemberContact (
	MemberId int not null
	,FirstName varchar(255)
	,MiddleName varchar(255)
	,LastName varchar(255)
	,Email varchar(255)
	,PhoneNumber varchar(15)
	,constraint pk_MemberContact_MemberId primary key clustered (MemberId)
	,constraint fk_MemberContact_MemberId foreign key (MemberId)
	references dbo.Member (MemberId)
	on update cascade
	,ValidFrom datetime2 generated always as row start not null
	,ValidTo datetime2 generated always as row end not null
	,period for system_time (ValidFrom,ValidTo)
) with (system_versioning = on (history_table = hist.MemberContact));
go
	
create table dbo.League (
	LeagueId int identity not null
	,LeagueName varchar(50) not null
	,DirectorId int not null
	,constraint pk_League_LeagueId primary key clustered (LeagueId)
	,constraint fk_League_LeagueDirectorId foreign key (DirectorId)
	references dbo.Member (MemberId)
	on update cascade
	,ValidFrom datetime2 generated always as row start not null
	,ValidTo datetime2 generated always as row end not null
	,period for system_time (ValidFrom,ValidTo)
) with (system_versioning = on (history_table = hist.League));
go

create table dbo.Team (
	TeamId int identity not null
	,TeamName varchar(50) not null
	,constraint pk_Team_TeamId primary key clustered (TeamId)
	,ValidFrom datetime2 generated always as row start not null
	,ValidTo datetime2 generated always as row end not null
	,period for system_time (ValidFrom,ValidTo)
) with (system_versioning = on (history_table = hist.Team));
go

create table ref.[Role] (
	RoleId int identity not null
	,RoleName varchar(255) not null
	,constraint pk_Role_RoleId primary key clustered (RoleId)
	,constraint uq_Role_RoleName unique (RoleName)
	,ValidFrom datetime2 generated always as row start not null
	,ValidTo datetime2 generated always as row end not null
	,period for system_time (ValidFrom,ValidTo)
) with (system_versioning = on (history_table = hist.TeamRole));
go

create table dbo.TeamMember (
	TeamId int not null
	,MemberId int not null
	,RoleId int not null
	,constraint pk_TeamMember_TeamMemberId primary key clustered (TeamId,MemberId)
	,constraint fk_TeamMember_TeamId foreign key (TeamId)
	references dbo.Team (TeamId)
	on update cascade
	,constraint fk_TeamMember_MemberId foreign key (MemberId)
	references dbo.Member (MemberId)
	on update cascade
	,constraint fk_TeamMember_RoleId foreign key (RoleId)
	references ref.[Role] (RoleId)
	on update cascade
	,ValidFrom datetime2 generated always as row start not null
	,ValidTo datetime2 generated always as row end not null
	,period for system_time (ValidFrom,ValidTo)
) with (system_versioning = on (history_table = hist.TeamMember));
go

create table dbo.Game (
	GameId int identity not null
	,GameDate date not null
	,constraint pk_Game_GameId primary key clustered (GameId)
	,ValidFrom datetime2 generated always as row start not null
	,ValidTo datetime2 generated always as row end not null
	,period for system_time (ValidFrom,ValidTo)
) with (system_versioning = on (history_table = hist.Game));
go

create table dbo.PlayerResult (
	GameId int not null
	,MemberId int not null
	,Winner bit
	,constraint pk_PlayerResult_GameMemberId primary key clustered (GameId,MemberId)
	,constraint uq_PlayerResult_GameResult unique (GameId,Winner)
	,constraint fk_PlayerResult_GameId foreign key (GameId)
	references dbo.Game (GameId)
	on update cascade
	,constraint fk_PlayerResult_MemberId foreign key (MemberId)
	references dbo.Member (MemberId)
	on update cascade
	,ValidFrom datetime2 generated always as row start not null
	,ValidTo datetime2 generated always as row end not null
	,period for system_time (ValidFrom,ValidTo)
) with (system_versioning = on (history_table = hist.GameResult));
go