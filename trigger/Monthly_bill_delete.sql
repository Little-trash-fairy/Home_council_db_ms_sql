Use Homeowners_Association;
Go

CREATE TRIGGER Monthly_bill_delete
	ON Monthly_bill
	INSTEAD OF DELETE
AS
	DECLARE @id_monthly_bill							int;

	DECLARE del_monthly_bill CURSOR FOR 
		SELECT id_monthly_bill
			FROM deleted

	OPEN del_monthly_bill

    FETCH NEXT FROM del_monthly_bill INTO @id_monthly_bill
	WHILE @@FETCH_STATUS = 0
		Begin
			if Not exists(select id_monthly_bill from Monthly_bill 
							where id_monthly_bill = @id_monthly_bill and is_zip = 0)
				Begin
					Print('Данного месячного счёта в базе данных нет')
				End
			Else
				Begin
					update Monthly_bill
						Set is_zip						=			1
							where id_monthly_bill		=			@id_monthly_bill
					Update	List_of_services
						set is_zip						=			1
							where id_monthly_bill		=			@id_monthly_bill
				End
			FETCH NEXT FROM del_monthly_bill INTO @id_monthly_bill
		End

	CLOSE del_monthly_bill
	DEALLOCATE del_monthly_bill