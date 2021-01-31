Use Homeowners_Association;
Go

CREATE TRIGGER Provider_delete
	ON Provider
	INSTEAD OF DELETE
AS
	DECLARE @id_provider												int;

	DECLARE del_Provider CURSOR FOR 
		SELECT id_provider
			FROM deleted

	OPEN del_Provider

    FETCH NEXT FROM del_Provider INTO @id_provider
	WHILE @@FETCH_STATUS = 0
		Begin
			if Not exists(select id_provider from Provider 
							where id_provider = @id_provider and is_zip = 0)
				Begin
					Print('Данного счётчика в базе данных нет')
				End
			Else
				Begin
					Update	Provider
						set is_zip						=			1
							where id_provider			=			@id_provider
				End
			FETCH NEXT FROM del_Provider INTO @id_provider
		End

	CLOSE del_Provider
	DEALLOCATE del_Provider