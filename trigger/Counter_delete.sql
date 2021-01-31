Use Homeowners_Association;
Go

CREATE TRIGGER Counter_delete
	ON Counter
	INSTEAD OF DELETE
AS
	DECLARE @id_counter												int,
			@error_str												nvarchar(255);

	DECLARE del_Counter CURSOR FOR 
		SELECT id_counter
			FROM deleted

	OPEN del_Counter

    FETCH NEXT FROM del_Counter INTO @id_counter
	WHILE @@FETCH_STATUS = 0
		Begin
			if Not exists(select id_counter from Counter 
							where id_counter = @id_counter and is_zip = 0)
				Begin
					Set	@error_str						=			'Данного счётчика в базе данных нет'
					GoTO Error_label
				End
					Update	Counter
						set is_zip						=			1
							where id_counter			=			@id_counter
		Error_label:
			if @error_str is Not NULL
				Begin
					Print(@error_str)
					set @error_str						=			null
				End
			FETCH NEXT FROM del_Counter INTO @id_counter
		End

	CLOSE del_Counter
	DEALLOCATE del_Counter