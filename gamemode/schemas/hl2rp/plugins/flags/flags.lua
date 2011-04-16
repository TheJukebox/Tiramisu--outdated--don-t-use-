function CAKE.MakeCombine( ply, rank )

	if ValidEntity( ply ) then
		if CAKE.RankExists( "CCA", rank ) then
			CAKE.JoinGroup( ply, "CCA" )
			CAKE.SetCharRank( ply, "CCA", rank )
			CAKE.SendError( ply, "Your flag has been set to " .. rank )
			local name = "CCA.C" .. CAKE.CityNumber .. "." .. string.upper( rank ) .. "-" .. CAKE.GetCharField(ply, "cid" )
			CAKE.SetCharField(ply, "name", name )
			ply:SetNWString( "name", name )
		elseif CAKE.RankExists( "Overwatch", rank ) then
			CAKE.JoinGroup( ply, "Overwatch" )
			CAKE.SetCharRank( ply, "Overwatch", rank )
			CAKE.SendError( ply, "Your flag has been set to " .. rank )
			local name = "COTA.C" .. CAKE.CityNumber .. "." .. string.upper( rank ) .. "-" .. CAKE.GetCharField(ply, "cid" )
			CAKE.SetCharField(ply, "name", name )
			ply:SetNWString( "name", name )
		end
	end

end

function CAKE.IsCombine( ply )

	if CAKE.GroupExists( CAKE.GetCharField( ply, "group" ) ) then
		if CAKE.GetGroupFlag( CAKE.GetCharField( ply, "group" ) , "iscombine" ) then
			return true
		end
	end

	return false

end


local function Admin_SetFlag( ply, cmd, args )

	local target = CAKE.FindPlayer( args[1] )
	local rank = args[2]

	if ValidEntity( target) then
		if CAKE.RankExists( "CCA", rank ) or CAKE.RankExists( "Overwatch", rank ) then
			CAKE.MakeCombine( target, rank )
		elseif CAKE.RankExists( "Resistance", rank ) then
			CAKE.JoinGroup( ply, "Resistance" )
			CAKE.SetCharRank( ply, "Resistance", rank )
			CAKE.SendError( ply, "Your flag has been set to " .. rank )
		elseif !args[2] then
			CAKE.SendError( ply, "Your flag has been set to none" )
			CAKE.LeaveGroup( target )
		end
	else
		CAKE.SendConsole( ply, "Player Not Found!" )
	end

end

CAKE.AdminCommand( "setflag", Admin_SetFlag, "Sets a player's combine/rebel flag", true, true, 1 );

local function Admin_ListFlags( ply, cmd, args )

	CAKE.SendChat( ply, "---List of Flags---" );
	CAKE.SendChat( ply, "---Use rp_admin setflag playername flag---\n" );

	CAKE.SendChat( ply, "---CCA\n" );
	for rank, tbl in pairs( CAKE.Groups["CCA"]["Ranks"] ) do

		CAKE.SendChat( ply, rank .. " - " .. tbl.formalname .. "\n" )
		
	end

	CAKE.SendChat( ply, "---Overwatch\n" );
	for rank, tbl in pairs( CAKE.Groups["Overwatch"]["Ranks"] ) do

		CAKE.SendChat( ply, rank .. " - " .. tbl.formalname .. "\n" )
		
	end

	CAKE.SendChat( ply, "---Resistance\n" );
	for rank, tbl in pairs( CAKE.Groups["Resistance"]["Ranks"] ) do

		CAKE.SendChat( ply, rank .. " - " .. tbl.formalname .. "\n" )
		
	end

end

CAKE.AdminCommand( "listflags", Admin_ListFlags, "Lists all flags", true, true, 1 );