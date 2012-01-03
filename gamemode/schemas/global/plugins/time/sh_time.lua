local monthstable = {
	[1] = "January",
	[2] = "February",
	[3] = "March",
	[4] = "April",
	[5] = "May",
	[6] = "June",
	[7] = "July",
	[8] = "August",
	[9] = "September",
	[10] = "October",
	[11] = "November",
	[12] = "December"
}

function CAKE.FindMonthName()

	local formatted = GetGlobalString( "time" )
	local exp = string.Explode( "/", formatted )
	local months = exp[1]
	
	return monthstable[ tonumber( months ) ]

end

function CAKE.FindMonthNumber()

	local formatted = GetGlobalString( "time" )
	local exp = string.Explode( "/", formatted )
	local months = exp[1]
	
	return tonumber( months )
	
end

function CAKE.FindYear()
	
	local formatted = GetGlobalString( "time" )
	local exp = string.Explode( "/", formatted )
	local exp2 = string.Explode( "-", exp[3] )
	
	return tonumber( exp2[ 1 ] ) or 0

end

function CAKE.IsLeapYear()

	local year = CAKE.FindYear()

	if year < 1582 then
		return false --Gregorian calendar wasn't set, therefore, leap years do not yet exist.
	end

	if ( year % 4 ) == 0 then
		return true
	end
	
	return false
	
end

function CAKE.FindDayNumber()

	local formatted = GetGlobalString( "time" )
	local exp = string.Explode( "/", formatted )
	local day = exp[2]
	
	return tonumber( day )

end

function CAKE.FindCentury()
	
	local year = CAKE.FindYear() or 0
	return math.floor( year / 100 ) + 1
	
end

local leapyearmonths = {
	[ "January" ] = 6,
	[ "February" ] = 2,
	[ "March" ] = 3,
	[ "April" ] = 6,
	[ "May" ] = 1,
	[ "June" ] = 4,
	[ "July" ] = 6,
	[ "August" ] = 2,
	[ "September" ] = 5,
	[ "October" ] = 0,
	[ "November" ] = 3,
	[ "December" ] = 5
}

local regularmonths = {
	[ "January" ] = 0,
	[ "February" ] = 3,
	[ "March" ] = 3,
	[ "April" ] = 6,
	[ "May" ] = 1,
	[ "June" ] = 4,
	[ "July" ] = 6,
	[ "August" ] = 2,
	[ "September" ] = 5,
	[ "October" ] = 0,
	[ "November" ] = 3,
	[ "December" ] = 5
}

local daytable = {
	[ 0 ] = "Sunday",
	[ 1 ] = "Monday",
	[ 2 ] = "Tuesday",
	[ 3 ] = "Wednesday",
	[ 4 ] = "Thursday",
	[ 5 ] = "Friday",
	[ 6 ] = "Saturday"
}

local centurytable = {
	[ 18 ] = 4,
	[ 19 ] = 2,
	[ 20 ] = 0,
	[ 21 ] = 6,
	[ 22 ] = 4,
	[ 23 ] = 2,
	[ 24 ] = 0,
	[ 25 ] = 6,
	[ 26 ] = 4,
	[ 27 ] = 2,
	[ 28 ] = 0,
	[ 29 ] = 6,
	[ 30 ] = 4,
	[ 31 ] = 2
}

function CAKE.FindDayName()

	if CAKE.FindYear() < 1582 then
		return "Unknown"
	end
	
	local centurynumber = centurytable[ CAKE.FindCentury() ] or 0
	local last2digits = CAKE.FindYear() - ( CAKE.FindCentury() - 1 ) * 100
	local yearnumber = math.floor( last2digits / 4 )
	local monthnumber = 0
	
	if CAKE.IsLeapYear() then
		monthnumber = leapyearmonths[ CAKE.FindMonthName() ]
	else
		monthnumber = regularmonths[ CAKE.FindMonthName() ]
	end
	
	return daytable[ ( centurynumber + last2digits + yearnumber + monthnumber + CAKE.FindDayNumber() ) % 7 ]
	

end