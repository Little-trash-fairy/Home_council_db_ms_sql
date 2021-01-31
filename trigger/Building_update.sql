Use Homeowners_Association;
Go

CREATE TRIGGER Building_update
	ON Building
	INSTEAD OF Update
AS
	DECLARE @id_building							int,
			@street									nvarchar(50),
			@house_number							nvarchar(6),
			@number_of_apartments					int,
			@tenants_count							int,
			@total_house_area						Decimal(18,0),
			@area_of_public_areas					Decimal(18,0),
			@del_street								nvarchar(50),
			@del_house_number						nvarchar(6),
			@del_number_of_apartments				int,
			@del_tenants_count						int,
			@del_total_house_area					Decimal(18,0),
			@del_area_of_public_areas				Decimal(18,0);

	DECLARE ins_Building CURSOR FOR 
		SELECT id_building,street,house_number,number_of_apartments,tenants_count,total_house_area,area_of_public_areas
			FROM inserted
	DECLARE del_Building CURSOR FOR 
		SELECT street,house_number,number_of_apartments,tenants_count,total_house_area,area_of_public_areas
			FROM deleted

	OPEN ins_Building
	OPEN del_Building

	FETCH NEXT FROM del_Building INTO @del_street,@del_house_number,@del_number_of_apartments,@del_tenants_count,@del_total_house_area,@del_area_of_public_areas
	FETCH NEXT FROM ins_Building INTO @id_building,@street,@house_number,@number_of_apartments,@tenants_count,@total_house_area,@area_of_public_areas
	WHILE @@FETCH_STATUS = 0
		Begin
		--блок начальных проверок
		if  dbo.CheckValidname(@street) = 0
				Begin
					set @street							=	@del_street
					Print('ѕустое название улицы')
				End
			if dbo.CheckValidname(@house_number) = 0
				Begin
					set @house_number					=	@del_house_number
					Print('ѕустой номер дома')
				End
			if @number_of_apartments<=0 or 
				@number_of_apartments is NULL
				Begin
					set @number_of_apartments			=	@del_number_of_apartments
					Print(' оличество квартир не может быть меньше либо равно 0')
				End
			if @tenants_count<0 or 
				@tenants_count is NULL
				Begin
					set @tenants_count					=	@del_tenants_count
					Print(' оличество жильцов не может быть меньше 0')
				End
			if @area_of_public_areas<0 or 
				@area_of_public_areas is NULL
				Begin
					set @area_of_public_areas			=	@del_area_of_public_areas
					Print('ќбщедоступна€ площадь дома не может быть меньше 0')
				End
			if @total_house_area<=0 or 
				(@total_house_area-@area_of_public_areas)<=0 or 
				@total_house_area is NULL
				Begin
					set @area_of_public_areas			=	@del_area_of_public_areas
					Print('ќбща€ площадь дома не может быть'+
						  'меньше 0 и меньше либо равной общедоступной'+
															'площади')
				End
		--ќпераци€
			Update Building
				Set					
					street								=	@street,
					house_number						=	@house_number,						
					number_of_apartments				=	@number_of_apartments,				
					tenants_count						=	@tenants_count,
					total_house_area					=	@total_house_area,						
					area_of_public_areas				=	@area_of_public_areas					
						where id_building = @id_building
			FETCH NEXT FROM del_Building INTO @del_street,@del_house_number,@del_number_of_apartments,@del_tenants_count,@del_total_house_area,@del_area_of_public_areas
			FETCH NEXT FROM ins_Building INTO @id_building,@street,@house_number,@number_of_apartments,@tenants_count,@total_house_area,@area_of_public_areas
		End
	Close del_Building
	Close ins_Building
	Deallocate del_Building
	Deallocate ins_Building