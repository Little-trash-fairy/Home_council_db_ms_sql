Use Homeowners_Association;
Go

CREATE TRIGGER Rate_delete
	ON Rate
	INSTEAD OF DELETE
AS
	DECLARE @id_rate												int;

	DECLARE del_Rate CURSOR FOR 
		SELECT id_rate
			FROM deleted

	OPEN del_Rate

    FETCH NEXT FROM del_Rate INTO @id_rate
	WHILE @@FETCH_STATUS = 0
		Begin
			if Not exists(select id_rate from Rate 
							where id_rate = @id_rate and is_zip = 0)
				Begin
					Print('Данного тарифа в базе данных нет')
				End
			Else
				Begin
					Update	Rate
						set is_zip						=			1
							where id_rate				=			@id_rate
				End
			FETCH NEXT FROM del_Rate INTO @id_rate
		End

	CLOSE del_Rate
	DEALLOCATE del_Rate