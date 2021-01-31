Use Homeowners_Association;
Go

Create TRIGGER Flat_delete
	ON Flat
	INSTEAD OF DELETE
AS
	DECLARE @deleted_flat								int,
			@buf_id										int,
			@buf2										int;
	DECLARE del_Flat CURSOR FOR 
		SELECT id_flat,id_building
			FROM deleted

	OPEN del_Flat

	FETCH NEXT FROM del_Flat INTO @deleted_flat,@buf2
	WHILE @@FETCH_STATUS = 0
		Begin
			if exists(select id_flat from Flat 
							where id_flat = @deleted_flat and is_zip = 0)
				Begin
				Set		@buf_id						=			(select id_monthly_bill 
																	from Monthly_bill
																		Where id_monthly_bill = @deleted_flat)
					update Tenant_of_flat
						Set is_zip					=			1
						where id_flat				=			@deleted_flat
					update Monthly_bill
						Set is_zip					=			1
						where id_monthly_bill		=			@buf_id
					update List_of_services
						Set is_zip					=			1
						where id_monthly_bill		=			@buf_id
					update Flat
						Set is_zip					=			1
						where id_flat				=			@deleted_flat
					update Building
						Set number_of_apartments	=			number_of_apartments - 1
							Where id_building		=			@buf2
				End
			else
				Begin
					Print('ƒанный житель не прописан в этой квартире')
				End
			FETCH NEXT FROM del_Flat INTO @deleted_flat,@buf2
		End
	Close del_Flat
	Deallocate del_Flat