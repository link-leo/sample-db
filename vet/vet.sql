use master
go

create database vet
go

use vet
go

/****************
* CREATE SCHEMA *
****************/

create schema hist;
go

create schema ref;
go

create schema xwlk;
go

create table dbo.[Provider] (
	ProviderId int identity not null
	,FirstName varchar(255)
	,MiddleName varchar(255)
	,LastName varchar(255)
	,PhoneNumber varchar(15)
	,StartDate date
	,EndDate date
	,constraint pk_Provider_ProviderId primary key clustered (ProviderId)
	,ValidFrom datetime2 generated always as row start not null
	,ValidTo datetime2 generated always as row end not null
	,period for system_time (ValidFrom,ValidTo)
) with (system_versioning = on (history_table = hist.[Provider]));
go

create table ref.AnimalType (
	AnimalTypeId int identity not null
	,AnimalTypeName varchar(255)
	,constraint pk_AnimalType_AnimalTypeId primary key clustered (AnimalTypeId)
	,ValidFrom datetime2 generated always as row start not null
	,ValidTo datetime2 generated always as row end not null
	,period for system_time (ValidFrom,ValidTo)
) with (system_versioning = on (history_table = hist.AnimalType));
go

create table dbo.Patient (
	PatientId int identity not null
	,AnimalTypeId int
	,PatientName varchar(255)
	,PatientDOB date
	,constraint pk_Patient_PatientId primary key clustered (PatientId)
	,constraint fk_Patient_AnimalTypeId foreign key (AnimalTypeId)
	references ref.AnimalType (AnimalTypeId)
	on delete set null
	on update cascade
	,ValidFrom datetime2 generated always as row start not null
	,ValidTo datetime2 generated always as row end not null
	,period for system_time (ValidFrom,ValidTo)
) with (system_versioning = on (history_table = hist.Patient));
go

create table dbo.[Owner] (
	OwnerId int identity not null
	,FirstName varchar(255)
	,MiddleName varchar(255)
	,LastName varchar(255)
	,PhoneNumber varchar(15)
	,constraint pk_Owner_OwnerId primary key clustered (OwnerId)
	,ValidFrom datetime2 generated always as row start not null
	,ValidTo datetime2 generated always as row end not null
	,period for system_time (ValidFrom,ValidTo)
) with (system_versioning = on (history_table = hist.Owner));
go

create table xwlk.PatientOwners (
	PatientId int
	,OwnerId int
	,constraint pk_PatientOwners_PatientOwnerId primary key clustered (PatientId,OwnerId)
	,constraint fk_PatientOwners_PatientId foreign key (PatientId)
	references dbo.Patient (PatientId)
	on update cascade
	,constraint fk_PatientOwners_OwnerId foreign key (OwnerId)
	references dbo.[Owner] (OwnerId)
	on update cascade
	,ValidFrom datetime2 generated always as row start not null
	,ValidTo datetime2 generated always as row end not null
	,period for system_time (ValidFrom,ValidTo)
) with (system_versioning = on (history_table = hist.PatientOwners));
go

create table ref.ReasonCode (
	ReasonCodeId int identity not null
	,ReasonCode varchar(6)
	,ReasonCodeDescription varchar(255)
	,constraint pk_ReasonCode_ReasonCodeId primary key clustered (ReasonCodeId)
	,constraint uq_ReasonCode_ReasonCode unique (ReasonCode)
	,ValidFrom datetime2 generated always as row start not null
	,ValidTo datetime2 generated always as row end not null
	,period for system_time (ValidFrom,ValidTo)
) with (system_versioning = on (history_table = hist.ReasonCode));
go

create table ref.TreatmentCode (
	TreatmentCodeId int identity not null
	,TreatmentCode varchar(6)
	,TreatmentCodeDescription varchar(255)
	,constraint pk_TreatmentCode_TreatmentCodeId primary key clustered (TreatmentCodeId)
	,constraint uq_TreatmentCode_TreatmentCode unique (TreatmentCode)
	,ValidFrom datetime2 generated always as row start not null
	,ValidTo datetime2 generated always as row end not null
	,period for system_time (ValidFrom,ValidTo)
) with (system_versioning = on (history_table = hist.TreatmentCode));
go

create table dbo.Visit (
	VisitId int identity not null
	,VisitDateTime datetime2
	,constraint pk_Visit_VisitId primary key clustered (VisitId)
	,ValidFrom datetime2 generated always as row start not null
	,ValidTo datetime2 generated always as row end not null
	,period for system_time (ValidFrom,ValidTo)
) with (system_versioning = on (history_table = hist.Visit));
go

create table xwlk.VisitProvider (
	VisitProviderId int identity not null
	,VisitId int
	,ProviderId int
	,constraint pk_VisitProvider_VisitProviderId primary key clustered (VisitProviderId)
	,constraint fk_VisitProvider_VisitId foreign key (VisitId)
	references dbo.Visit (VisitId)
	on delete set null
	on update cascade
	,constraint fk_VisitProvider_ProviderId foreign key (ProviderId)
	references dbo.[Provider] (ProviderId)
	on delete set null
	on update cascade
	,constraint uq_VisitProvider_VisitProviderId unique (VisitId,ProviderId)
	,ValidFrom datetime2 generated always as row start not null
	,ValidTo datetime2 generated always as row end not null
	,period for system_time (ValidFrom,ValidTo)
) with (system_versioning = on (history_table = hist.VisitProvider));
go

create table xwlk.VisitPatient (
	VisitPatientId int identity not null
	,VisitId int
	,PatientId int
	,constraint pk_VisitPatient_VisitPatientId primary key clustered (VisitPatientId)
	,constraint fk_VisitProvider_VisitId foreign key (VisitId)
	references dbo.Visit (VisitId)
	on delete set null
	on update cascade
	,constraint fk_Visit_PatientId foreign key (PatientId)
	references dbo.Patient (PatientId)
	on delete set null
	on update cascade
	,constraint uq_VisitPatient_VisitPatientId unique (VisitId,PatientId)
	,ValidFrom datetime2 generated always as row start not null
	,ValidTo datetime2 generated always as row end not null
	,period for system_time (ValidFrom,ValidTo)
) with (system_versioning = on (history_table = hist.VisitPatient));
go

create table xwlk.VisitReason (
	VisitReasonId int not null
	,VisitId int
	,ReasonCodeId int
	,constraint pk_VisitReason_VisitReasonId primary key clustered (VisitReasonId)
	,constraint fk_VisitReason_VisitId foreign key (VisitId)
	references dbo.Visit (VisitId)
	on delete set null
	on update cascade
	,constraint fk_VisitReason_ReasonCodeId foreign key (ReasonCodeId)
	references ref.ReasonCode (ReasonCodeId)
	on delete set null
	on update cascade
	,constraint uq_VisitReason_VisitReasonCode unique (VisitId,ReasonCodeId)
	,ValidFrom datetime2 generated always as row start not null
	,ValidTo datetime2 generated always as row end not null
	,period for system_time (ValidFrom,ValidTo)
) with (system_versioning = on (history_table = hist.VisitReason));
go

create table xwlk.VisitReasonTreatment (
	VisitReasonTreatmentId int not null
	,VisitReasonId int
	,TreatmentCodeId int
	,constraint pk_VisitReasonTreatment_VisitReasonTreatmentId primary key clustered (VisitReasonTreatmentId)
	,constraint fk_VisitReasonTreatment_VisitReasonId foreign key (VisitReasonId)
	references xwlk.VisitReason (VisitReasonId)
	on delete set null
	on update cascade
	,constraint fk_VisitReasonTreatment_TreatmentCodeId foreign key (TreatmentCodeId)
	references ref.TreatmentCode (TreatmentCodeId)
	on delete set null
	on update cascade
	,ValidFrom datetime2 generated always as row start not null
	,ValidTo datetime2 generated always as row end not null
	,period for system_time (ValidFrom,ValidTo)
) with (system_versioning = on (history_table = hist.VisitReasonTreatment));
go

/***************
* CREATE VIEWS *
***************/

create schema rpt;
go

create or alter view rpt.vwPatientRoster as
select
	p.PatientId
	,p.PatientName
	,a.AnimalTypeName
	,p.PatientDOB
from dbo.Patient p
left join ref.AnimalType a
	on a.AnimalTypeId=p.AnimalTypeId;
go

create or alter view rpt.vwPatientOwners as
select
	pr.PatientId
	,pr.PatientName
	,pr.AnimalTypeName
	,pr.PatientDOB
	,coalesce(o.LastName+', '+o.FirstName,o.LastName,o.FirstName) OwnerName
	,o.PhoneNumber
from rpt.vwPatientRoster pr
left join xwlk.PatientOwners po
	on po.PatientId=pr.PatientId
left join dbo.[Owner] o
	on o.OwnerId=po.OwnerId;
go

create or alter view rpt.vwVisitSummary as
select
	v.VisitId
	,v.VisitDateTime
	,pr.PatientId
	,pr.PatientName
	,pr.AnimalTypeName
	,pr.PatientDOB
	,rc.ReasonCode
	,rc.ReasonCodeDescription
	,tc.TreatmentCode
	,tc.TreatmentCodeDescription
from dbo.Visit v
left join xwlk.VisitPatient vp
	on vp.VisitId=v.VisitId
left join rpt.vwPatientRoster pr
	on pr.PatientId=vp.PatientId
left join xwlk.VisitReason vr
	on vr.VisitId=v.VisitId
left join ref.ReasonCode rc
	on rc.ReasonCodeId=vr.ReasonCodeId
left join xwlk.VisitReasonTreatment vrt
	on vrt.VisitReasonId=vr.VisitReasonId
left join ref.TreatmentCode tc
	on tc.TreatmentCodeId=vrt.TreatmentCodeId;
go