Use Homeowners_Association;
Go

CREATE TRIGGER Apartment_number_delete
	ON Apartment_number
	INSTEAD OF DELETE
AS
	DECLARE @deleted_numb								int;

	DECLARE del_apartment_number CURSOR FOR 
		SELECT id_apartment_number
			FROM deleted

	OPEN del_apartment_number

    FETCH NEXT FROM del_apartment_number INTO @deleted_numb
	WHILE @@FETCH_STATUS = 0
		Begin
			if Not exists(select flat_number from Flat 
							where flat_number = @deleted_numb) And
				exists(select id_apartment_number from Apartment_number 
							where id_apartment_number = @deleted_numb and is_zip =0)
				Begin
					update Apartment_number
						Set is_zip					=			1
						where id_apartment_number	=			@deleted_numb
				End
			else
				Begin
					Print('Данный номер прикреплён к квартире')
				End
			FETCH NEXT FROM del_apartment_number INTO @deleted_numb
		End	
	Close		del_apartment_number
	DEALLOCATE 	del_apartment_number