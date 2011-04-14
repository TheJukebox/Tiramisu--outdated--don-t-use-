ITEM.Name = "Standard Police Armor";
ITEM.Class = "clothing_police";
ITEM.Description = "The standard for metrocops.";
ITEM.Model = "models/Police.mdl";
ITEM.Purchaseable = false;
ITEM.Price = 500;
ITEM.ItemGroup = 2;
ITEM.Flags = {
	"armor;70",
	"shieldratio;0.7",
	"explosivearmor;1.5",
	"kineticarmor;0.6",
	"bulletarmor;0.7"
}
ITEM.Content = {
	"materials/models/police/metrocop_sheet.vmt",
	"models/Police.mdl"
}
function ITEM:Drop(ply)
	
end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

end
