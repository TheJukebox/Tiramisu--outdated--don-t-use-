ITEM.Name = "Formal Clothes (2)";
ITEM.Class = "clothing_formal2";
ITEM.Description = "For the refined gentlemen";
ITEM.Model = "models/breen.mdl";
ITEM.Purchaseable = true;
ITEM.Price = 500;
ITEM.ItemGroup = 1;
ITEM.Flags = {
	"nogloves"
}
function ITEM:Drop(ply)

end

function ITEM:Pickup(ply)

	self:Remove();

end

function ITEM:UseItem(ply)

end
