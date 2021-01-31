Use Homeowners_Association;
Go

CREATE TRIGGER List_of_services_delete
	ON List_of_services
	INSTEAD OF DELETE
AS
	DECLARE @id_list_of_services						int;

	DECLARE del_List_of_services CURSOR FOR 
		SELECT id_list_of_services
			FROM deleted

	OPEN del_List_of_services

    FETCH NEXT FROM del_List_of_services INTO @id_list_of_services
	WHILE @@FETCH_STATUS = 0
		Begin
			if Not exists(select id_list_of_services from List_of_services 
							where id_list_of_services = @id_list_of_services and is_zip = 0)
				Begin
					Print('Данного счёта за услугу в базе данных нет')
				End
			Else
				Begin
					Update	List_of_services
						set is_zip						=			1
							where id_list_of_services	=			@id_list_of_services
				End
			FETCH NEXT FROM del_List_of_services INTO @id_list_of_services
		End

	CLOSE del_List_of_services
	DEALLOCATE del_List_of_services