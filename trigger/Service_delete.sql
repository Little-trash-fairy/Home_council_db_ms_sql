Use Homeowners_Association;
Go

CREATE TRIGGER Service_delete
	ON Service
	INSTEAD OF DELETE
AS
	DECLARE @id_service												int;

	DECLARE del_Service CURSOR FOR 
		SELECT id_service
			FROM deleted

	OPEN del_Service

    FETCH NEXT FROM del_Service INTO @id_service
	WHILE @@FETCH_STATUS = 0
		Begin
			if Not exists(select id_service from Service 
							where id_service = @id_service and is_zip = 0)
				Begin
					Print('Данного услуги в базе данных нет')
				End
			Else
				Begin
					Update	Service
						set is_zip						=			1
							where id_service			=			@id_service
				End
			FETCH NEXT FROM del_Service INTO @id_service
		End

	CLOSE del_Service
	DEALLOCATE del_Service