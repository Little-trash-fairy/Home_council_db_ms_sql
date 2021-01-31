CREATE DATABASE Homeowners_Association
COLLATE Cyrillic_General_100_CI_AI;
GO

USE Homeowners_Association;
Go

CREATE TABLE Building
(
    id_building          int PRIMARY KEY IDENTITY (1, 1),
    street               NVARCHAR(50)                             Not Null,
    house_number         NVARCHAR(6)                              Not Null,
    number_of_apartments int CHECK (number_of_apartments > 0)     Not Null,
    tenants_count        int                                      Not Null,
    total_house_area     decimal CHECK (total_house_area > 0)     Not Null,
    area_of_public_areas decimal CHECK (area_of_public_areas > 0) Not Null,
	is_zip				 bit	default 0
)

CREATE TABLE Counter
(
    id_counter        int PRIMARY KEY IDENTITY (1, 1),
    date_check        date Not Null,
    installation_date date Not Null,
	is_zip			  bit	default 0
)

CREATE TABLE Provider
(
    id_provider   int PRIMARY KEY IDENTITY (1, 1),
    provider_name nvarchar(250) Not Null,
	is_zip		  bit	default 0
)

CREATE TABLE Rate
(
    id_rate     int PRIMARY KEY IDENTITY (1, 1),
    date_begin  date                                      Not Null,
    date_end    date                                      Not Null,
    price       money                                     Not Null,
    id_provider int references Provider (id_provider)     Not Null,
	is_zip		bit	default 0
)

CREATE TABLE Apartment_number
(
    id_apartment_number int PRIMARY KEY IDENTITY (1, 1),
    apartment_number    nvarchar(8) Not Null,
	is_zip				bit	default 0
)

CREATE TABLE Benefits
(
    id_benefits     int PRIMARY KEY IDENTITY (1, 1),
    benefits_name   nvarchar(30) Not Null,
    benefits_factor money        Not Null,
	is_zip			bit	default 0
)

CREATE TABLE Person
(
    payment_account    int PRIMARY KEY IDENTITY (1, 1),
    person_name        nvarchar(100) Not Null,
    Surname            nvarchar(100) Not Null,
    person_second_name nvarchar(100) Null,
    debt               money         Not Null,
    person_benefits    int           NULL references Benefits (id_benefits),
	is_zip			   bit	default 0
)

CREATE TABLE Flat
(
	id_flat				 int PRIMARY KEY IDENTITY (1, 1),
    area_apartments      decimal CHECK (area_apartments > 0)                       Not Null,
    count_tenant_of_flat int                                                       Not Null,
    flat_number          int references Apartment_number (id_apartment_number)     Not Null,
    id_building          int references Building (id_building)                     Not Null,
	tenant_payment_account int Not Null references Person (payment_account),
	is_zip				 bit	default 0
)

CREATE TABLE Tenant_of_flat
(
    id_flat				   int Not Null references Flat (id_flat),
    tenant_payment_account int Not Null references Person (payment_account),
	is_zip				   bit	default 0
)

CREATE TABLE Unit
(
    id_unit int PRIMARY KEY IDENTITY (1, 1),
    unit    nvarchar(8) Not Null,
	is_zip	bit	default 0
)

CREATE TABLE Service
(
    id_service                  int primary key identity (1,1),
    name_of_the_service         nvarchar(70)  Not Null,
    full_description            nvarchar(250) Not Null,
    Date_of_contract_conclusion date          Not Null,
    rate_id                     int           Not Null references Rate (id_rate),
    unit_id                     int           Not Null references Unit (id_unit),
	is_zip						bit			  default 0
)

Create Table Monthly_bill
(
    id_monthly_bill    int primary key IDENTITY (1, 1),
	id_flat			   int references Flat (id_flat),
    invoice_date       date Not Null,
	is_zip			   bit	default 0
)
Create Table List_of_services
(
    id_list_of_services int PRIMARY KEY identity (1,1),
	service_count		decimal(18,0) not null,
    service_id          int     Not Null references Service (id_service),
    counter_id          int     Not Null references Counter (id_counter),
	id_monthly_bill		int		Not Null references Monthly_bill (id_monthly_bill),
	price				money Not Null ,
	is_zip				bit		default 0
)