Use Homeowners_Association;
Go

CREATE TRIGGER Tenant_of_flat_delete
	ON Tenant_of_flat
	INSTEAD OF DELETE
AS
	DECLARE @deleted_flat								int,
			@deleted_person								int,
			@buf_id									int;

	Declare del_tenant cursor for
		select id_flat,tenant_payment_account
			From deleted

	Open del_tenant

	Fetch next from del_tenant INTO @deleted_flat,@deleted_person
	WHILE @@FETCH_STATUS = 0
		Begin
			if exists(select id_flat from Tenant_of_flat 
							where id_flat = @deleted_flat AND
								  tenant_payment_account = @deleted_person and is_zip = 0)
				Begin
					update Tenant_of_flat
						Set is_zip					=			1
						where id_flat				=			@deleted_flat AND
							  tenant_payment_account=			@deleted_person

					Set @buf_id = (select Top 1 id_building from Flat where id_flat = @deleted_flat)

					update Flat
						Set count_tenant_of_flat		=	count_tenant_of_flat - 1
							Where id_flat				=	@deleted_flat
					update Building
						Set tenants_count				=	tenants_count - 1
							Where id_building			=	@buf_id
							End
			else
				Begin
					Print('ƒанный житель не прописан в этой квартире')
				End
			Fetch next from del_tenant INTO @deleted_flat,@deleted_person
		End
	Close del_tenant
	Deallocate del_tenant