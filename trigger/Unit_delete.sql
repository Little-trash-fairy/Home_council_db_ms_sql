Use Homeowners_Association;
Go

CREATE TRIGGER Unit_delete
	ON Unit
	INSTEAD OF DELETE
AS
	DECLARE @id_unit												int;

	DECLARE del_Unit CURSOR FOR 
		SELECT id_unit
			FROM deleted

	OPEN del_Unit

    FETCH NEXT FROM del_Unit INTO @id_unit
	WHILE @@FETCH_STATUS = 0
		Begin
			if Not exists(select id_unit from Unit 
							where id_unit = @id_unit and is_zip = 0)
				Begin
					Print('Данной приставки в базе данных нет')
				End
			Else
				Begin
					Update	Unit
						set is_zip						=			1
							where id_unit				=			@id_unit
				End
			FETCH NEXT FROM del_Unit INTO @id_unit
		End

	CLOSE del_Unit
	DEALLOCATE del_Unit