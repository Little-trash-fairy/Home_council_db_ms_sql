Use Homeowners_Association;
Go

CREATE TRIGGER benefits_delete
	ON Benefits
	INSTEAD OF DELETE
AS
	DECLARE @deleted_id				int;

	DECLARE del_benefits CURSOR FOR 
		SELECT id_benefits
			FROM inserted


	OPEN del_benefits

	FETCH NEXT FROM del_benefits INTO @deleted_id
	WHILE @@FETCH_STATUS = 0
		Begin
			if exists(select id_benefits from Benefits where id_benefits = @deleted_id and is_zip = 0)
				Begin
					update Benefits
						Set is_zip				= 1
						where id_benefits		= @deleted_id

					update Person
						Set person_benefits		= NULL
						where person_benefits	= @deleted_id
				End
			else
				Begin
					Print('Ћьгота с id:= ' + CAST(@deleted_id AS nvarchar) + ' в базе данных не существует')
				End
			FETCH NEXT FROM del_benefits INTO @deleted_id
		End
	Close del_benefits
	Deallocate del_benefits