-------------------------------
-- CakeScript Generation 2
-- Author: LuaBanana ( Aka Jake )
-- Project Start: 5/24/2008
--
-- player_util.lua
-- Useful functions for players.
-------------------------------

function CAKE.SendChat( ply, msg )

	ply:PrintMessage( 3, msg );
	
end

function CAKE.SendConsole( ply, msg )

	ply:PrintMessage( 2, msg ); -- At least I THINK it is 2..
	
end

DecayingRagdolls = {};

function CAKE.DeathMode( ply )

	CAKE.DayLog( "script.txt", "Starting death mode for " .. ply:SteamID( ) );
	local mdl = ply:GetModel( )
	
	local rag = ents.Create( "prop_ragdoll" )
	rag:SetModel( mdl )
	rag:SetPos( ply:GetPos( ) )
	rag:SetAngles( ply:GetAngles( ) + Angle( 0, 90, 0 ) )
	rag.isdeathdoll = true;
	rag.ply = ply;
	rag:Spawn( )
	
	
	if( ply.Clothing ) then
		for k, v in pairs( ply.Clothing ) do
			if( ValidEntity( v ) ) then
				v:SetParent( rag )
				v:Initialize()
			end
		end
	end
	
	datastream.StreamToClients( ply, "RecieveViewRagdoll", { ["ragdoll"] = rag } )
	
	--ply:SetViewEntity( rag );
	
	ply.deathrag = rag;
	
	ply:SetNWInt( "deathmode", 1 )
	
	ply.deathtime = 0;
	ply.nextsecond = CurTime( ) + 1;
	
	timer.Simple( 60, function()
	
		ply:SetNWInt( "deathmode", 0 )
		ply:SetViewEntity( ply );

	
	end)
	
end

function ccGetCharInfo( ply, cmd, args )
	
	local target =  CAKE.FindPlayer( args[1] )
	local birthplace = CAKE.GetCharField( target, "birthplace" )
	local gender = CAKE.GetCharField( target, "gender" )
	local description = CAKE.GetCharField( target, "description" )
	local age = CAKE.GetCharField( target, "age" )
	local alignment = CAKE.GetCharField( target, "alignment" )
	umsg.Start("GetPlayerInfo", ply)
		umsg.Entity( target )
		umsg.String( birthplace )
		umsg.String( gender )
		umsg.String( description )
		umsg.String( age )
		umsg.String( alignment )
	umsg.End()
end
concommand.Add( "rp_getcharinfo", ccGetCharInfo )

local meta = FindMetaTable( "Player" );

function meta:ConCommand( cmd ) --Rewriting this due to Garry fucking it up.
		umsg.Start( "runconcommand", self )
			umsg.String( cmd )
		umsg.End()
end

function meta:MaxHealth( )

	return self:GetNWFloat("MaxHealth");
	
end

function meta:ChangeMaxHealth( amt )

	self:SetNWFloat("MaxHealth", self:MaxHealth() + amt);
	
end

function meta:MaxArmor( )

	return self:GetNWFloat("MaxArmor");
	
end

function meta:ChangeMaxArmor( amt )

	self:SetNWFloat("MaxArmor", self:MaxArmor() + amt);
	
end

function meta:MaxWalkSpeed( )

	return self:GetNWFloat("MaxWalkSpeed");
	
end

function meta:ChangeMaxWalkSpeed( amt )

	self:SetNWFloat("MaxWalkSpeed", self:MaxWalkSpeed() + amt);
	
end

function meta:MaxRunSpeed( )

	return self:GetNWFloat("MaxRunSpeed");
	
end

function meta:ChangeMaxRunSpeed( amt )

	self:SetNWFloat("MaxRunSpeed", self:MaxRunSpeed() + amt);
	
end

function meta:GiveItem( class )

	CAKE.DayLog( "economy.txt", "Adding item '" .. class .. "' to " .. CAKE.FormatCharString( self ) .. " inventory" );
	local inv = CAKE.GetCharField( self, "inventory" );
	table.insert( inv, class );
	CAKE.SetCharField( self, "inventory", inv);
	self:RefreshInventory( );

end

function meta:TakeItem( class )
	local inv = CAKE.GetCharField(self, "inventory" );
	
	for k, v in pairs( inv ) do
		if( v == class ) then
			inv[ k ] = nil;
			PrintTable( inv );
			CAKE.SetCharField( self, "inventory", inv);
			self:RefreshInventory( );
			CAKE.DayLog( "economy.txt", "Removing item '" .. class .. "' from " .. CAKE.FormatCharString( self ) .. " inventory" );
			return;
		end
	end
	
end

function meta:ClearInventory( )
	umsg.Start( "clearinventory", self )
	umsg.End( );
end

function meta:RefreshInventory( )
	self:ClearInventory( )
	
	for k, v in pairs( CAKE.GetCharField( self, "inventory" ) ) do
		umsg.Start( "addinventory", self );
			umsg.String( CAKE.ItemData[ v ].Name );
			umsg.String( CAKE.ItemData[ v ].Class );
			umsg.String( CAKE.ItemData[ v ].Description );
			umsg.String( CAKE.ItemData[ v ].Model );
		umsg.End( );
	end
end

function meta:ClearBusiness( )
	umsg.Start( "clearbusiness", self )
	umsg.End( );
end

function meta:RefreshBusiness( )
	self:ClearBusiness( )
		
	if(CAKE.Teams[self:Team()] == nil) then return; end -- Team not assigned
	local business = CAKE.GetCharField( self, "buygroups" )
	
	for k, v in pairs( CAKE.ItemData ) do
		if v.Purchaseable then
			if type( v.ItemGroup ) == "table" then
				for k2, v2 in pairs( business ) do
					if table.HasValue( v.ItemGroup, v2 ) then
						umsg.Start( "addbusiness", self );
						umsg.String( v.Name );
						umsg.String( v.Class );
						umsg.String( v.Description );
						umsg.String( v.Model );
						umsg.Long( v.Price );
						umsg.End( )		
					end
				end
			else
				if table.HasValue( business, v.ItemGroup ) then
					umsg.Start( "addbusiness", self );
						umsg.String( v.Name );
						umsg.String( v.Class );
						umsg.String( v.Description );
						umsg.String( v.Model );
						umsg.Long( v.Price );
					umsg.End( );
				end
			end
		end
	
	end
end

function meta:ItemHasFlag( item, flag )

	if !CAKE.ItemData[ item ].Flags then
		CAKE.ItemData[ item ].Flags = {}
		return false
	end
	
	for k, v in pairs( CAKE.ItemData[ item ].Flags ) do
		if type( v ) == "table" then
			for k2, v2 in pairs( v ) do
				if string.match( v2, flag ) then
					return true
				end
			end
		end
		if string.match( v, flag ) then
			return true
		end
	end
	
	return false

end

function meta:GetFlagValue( item, flag )

	if !CAKE.ItemData[ item ].Flags then
		CAKE.ItemData[ item ].Flags = {}
		return false
	end
	
	for k, v in pairs( CAKE.ItemData[ item ].Flags ) do
		if type( v ) == "table" then
			for k2, v2 in pairs( v ) do
				if string.match( v2, flag ) then
					local exp = string.Explode( ";", v2 )
					return exp[2] or true
				end
			end
		end
		if string.match( v, flag ) then
			local exp = string.Explode( ";", v )
			return exp[2] or true
		end
	end
	
	return false

end

function meta:IsCharLoaded()
	
	if CAKE.Teams[self:Team()] != nil then
		self:SetNWBool( "charloaded", true )
		return true
	else
		self:SetNWBool( "charloaded", false )
		return false
	end

end

function meta:HasItem( class )
	local inv = CAKE.GetCharField(self, "inventory" );
	for k, v in pairs( inv ) do
		if( v == class ) then
			return true
		end
	end
	return false
end

function CAKE.ChangeMoney( ply, amount ) -- Modify someone's money amount.

	-- Come on, Nori, how didn't you see the error in this?
	--if( ( CAKE.GetCharField( ply, "money" ) - amount ) < 0 ) then return; end 
	
	CAKE.DayLog( "economy.txt", "Changing " .. ply:SteamID( ) .. "-" .. ply:GetNWString( "uid" ) .. " money by " .. tostring( amount ) );
	
	CAKE.SetCharField( ply, "money", CAKE.GetCharField( ply, "money" ) + amount );
	if CAKE.GetCharField( ply, "money" ) < 0 then -- An actual negative number block
		CAKE.SetCharField( ply, "money", 0 );
		ply:SetNWString("money", "0" )
	else
		ply:SetNWString("money", CAKE.GetCharField( ply, "money" ));
	end

end

function CAKE.DrugPlayer( pl, mul ) -- DRUG DAT BITCH

	mul = mul / 10 * 2;

	pl:ConCommand("pp_motionblur 1")
	pl:ConCommand("pp_motionblur_addalpha " .. 0.05 * mul)
	pl:ConCommand("pp_motionblur_delay " .. 0.035 * mul)
	pl:ConCommand("pp_motionblur_drawalpha 1.00")
	pl:ConCommand("pp_dof 1")
	pl:ConCommand("pp_dof_initlength 9")
	pl:ConCommand("pp_dof_spacing 8")

	local IDSteam = string.gsub(pl:SteamID(), ":", "")

	timer.Create(IDSteam, 40 * mul, 1, CAKE.UnDrugPlayer, pl)
end

function CAKE.UnDrugPlayer(pl)
	pl:ConCommand("pp_motionblur 0")
	pl:ConCommand("pp_dof 0")
end