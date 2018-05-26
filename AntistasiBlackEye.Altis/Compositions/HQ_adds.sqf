params [["_type","delete",["sandbag","pad","lantern","net","delete","fuel"]]];
[[]] params ["_objs"];
private ["_padBag","_spawnPos","_itemType","_count","_item","_objc"];

if ((_type == "sandbag") AND ((server getVariable ["AS_HQ_sandbag", 0]) > 2)) exitWith {[petros,"BE","No more sandbags for you!"] remoteExec ["commsMP",Slowhand]};
if ((_type == "fuel") AND ((server getVariable ["AS_HQ_fuel_tank", 0]) > 1)) exitWith {[petros,"BE","One fuel tank is more than enough!"] remoteExec ["commsMP",Slowhand]};

if (_type == "pad") exitWith {
	if !(count (server getVariable ["obj_vehiclePad",[]]) > 0) then {
		{
			if (str typeof _x find "Land_Bucket_painted_F" > -1) then {
		    	[_x, {deleteVehicle _this}] remoteExec ["call", 0];
		   	};
		} forEach nearestObjects [petros, [], 80];
		_padBag = "Land_Bucket_painted_F" createVehicle [0,0,0];
		_padBag setPos ([getPos fuego, 2, floor(random 361)] call BIS_Fnc_relPos);
		[_padBag,"moveObject"] remoteExec ["AS_fnc_addActionMP"];
		[_padBag,"deploy"] remoteExec ["AS_fnc_addActionMP"];
		[_padBag,"removeObj"] remoteExec ["AS_fnc_addActionMP"];
	} else {
		[obj_vehiclePad, {deleteVehicle _this}] remoteExec ["call", 0];
		[obj_vehiclePad, {obj_vehiclePad = nil}] remoteExec ["call", 0];
		server setVariable ["AS_vehicleOrientation", 0, true];
		server setVariable ["obj_vehiclePad",[],true];

		["pad"] remoteExec ["HQ_adds",2];
	};
};

if (_type == "delete") exitWith {
	{
	    if ((  str typeof _x find "Land_Camping_Light_F" > -1
	   	    or str typeof _x find "Land_BagFence_Round_F" > -1
					or str typeof _x find "Land_WaterTank_F" > -1
	       	or str typeof _x find "CamoNet_BLUFOR_open_F" > -1))
		then {
	       	_objs pushBack _x;
	   	};
	} forEach nearestObjects [getPos fuego, [], 50];

	{
		deleteVehicle _x;
	} foreach _objs;

	server setVariable ["AS_HQ_sandbag",0,true];
	if (count (server getVariable ["obj_vehiclePad",[]]) > 0) then {
		[obj_vehiclePad, {deleteVehicle _this}] remoteExec ["call", 0];
		[obj_vehiclePad, {obj_vehiclePad = nil}] remoteExec ["call", 0];
		server setVariable ["AS_vehicleOrientation", 0, true];
		server setVariable ["obj_vehiclePad",[],true];
	};
};

call {
	_spawnPos = [getPos fuego, 10, floor(random 361)] call BIS_Fnc_relPos;

	if (_type == "lantern") exitWith {
		_itemType = "Land_Camping_Light_F";
	};

	if (_type == "net") exitWith {
		_itemType = "CamoNet_BLUFOR_open_F";
	};

	if (_type == "fuel") exitwith {
		_itemType = "Land_WaterTank_F";
		_count = server getVariable ["AS_HQ_fuel_tank", 0];
		server setVariable ["AS_HQ_fuel_tank", _count + 1,true];
	};

	if (_type == "sandbag") exitWith {
		_count = server getVariable ["AS_HQ_sandbag", 0];
		server setVariable ["AS_HQ_sandbag", _count + 1,true];
	};
};

if (_itemType == "Land_WaterTank_F") then {
	_item = _itemType createVehicle [0,0,0];
	_item setpos _spawnPos;
	_item allowdamage false;
	_item enablesimulation false;
	[_item, 0] call ace_refuel_fnc_makeSource;
}
else {
	_item = _itemType createVehicle [0,0,0];
	_item setpos _spawnPos;
	_item allowdamage false;
	_item enablesimulation false;
};







[_item,"moveObject"] remoteExec ["AS_fnc_addActionMP"];
[_item,"removeObj"] remoteExec ["AS_fnc_addActionMP"];
