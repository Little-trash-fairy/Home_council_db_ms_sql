Use Homeowners_Association;
Go

CREATE TRIGGER Building_delete
	ON Building
	INSTEAD OF DELETE
AS
	DECLARE @id_building								int,
			@buf_id										int,
			@buf_id_second								int;

	DECLARE del_Building CURSOR FOR 
		SELECT id_building
			FROM inserted


	OPEN del_Building

	FETCH NEXT FROM del_Building INTO @id_building
	WHILE @@FETCH_STATUS = 0
		Begin
			if exists(select id_building from Building 
							where id_building = @id_building and is_zip = 0)
				Begin
				DECLARE build_delete CURSOR FOR 
						SELECT id_flat,id_building
							FROM Flat
								where id_building = @id_building

				OPEN build_delete
				   --считываем данные первой строки в наши переменные
				 FETCH NEXT FROM build_delete INTO @buf_id
				 WHILE @@FETCH_STATUS = 0
					BEGIN
						Set		@buf_id_second			=			(select id_monthly_bill 
																		from Monthly_bill
																			Where id_flat = @buf_id)
						update Tenant_of_flat
							Set is_zip					=			1
							where id_flat				=			@buf_id
						update Monthly_bill
							Set is_zip					=			1
							where id_monthly_bill		=			@buf_id_second
						update List_of_services
							Set is_zip					=			1
							where id_monthly_bill		=			@buf_id_second
						update Flat
							Set is_zip					=			1
							where id_flat				=			@buf_id
						FETCH NEXT FROM build_delete INTO @buf_id
				   END
   
				   CLOSE build_delete
				   DEALLOCATE build_delete

				   Update Building
						Set is_zip						=			1
							where id_building			=			@id_building
				End
			else
				Begin
					Print('В базе данных данного дома не существует')
				End
			FETCH NEXT FROM del_Building INTO @id_building
		End
	Close del_Building
	Deallocate del_Building