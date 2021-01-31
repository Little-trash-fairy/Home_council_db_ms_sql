Use Homeowners_Association;
Go

CREATE TRIGGER person_delete
	ON Person
	INSTEAD OF DELETE
AS
	DECLARE @deleted_id				int,
			@buf_id					int;

	DECLARE del_Person CURSOR FOR 
		SELECT payment_account
			FROM deleted

	OPEN del_Person

    FETCH NEXT FROM del_Person INTO @deleted_id
	WHILE @@FETCH_STATUS = 0
		Begin
			if exists(select payment_account from Person where payment_account = @deleted_id and is_zip = 0)
				Begin
					update Person
						Set is_zip						= 1
						where person_benefits			= @deleted_id


					declare dec_count cursor for
						Select id_flat
							from Tenant_of_flat
								where tenant_payment_account	= @deleted_id
					Open dec_count
					FETCH NEXT FROM dec_count INTO @buf_id
					WHILE @@FETCH_STATUS = 0
						Begin
							Update Flat
								Set count_tenant_of_flat = count_tenant_of_flat -1
									where id_flat = @buf_id
							Set @buf_id = (select id_building from Flat where id_flat = @buf_id)
							Update Building
								Set tenants_count = tenants_count -1
									where id_building = @buf_id
							FETCH NEXT FROM dec_count INTO @buf_id
						End
					Close dec_count
					deallocate dec_count


					update Tenant_of_flat
						Set is_zip						= 1
						where tenant_payment_account	= @deleted_id
				End
			else
				Begin
					Print('Жильца с id:= ' + @deleted_id + ' в базе данных не существует')
				End
			FETCH NEXT FROM del_Person INTO @deleted_id
		End
	Close del_Person
	deallocate del_Person