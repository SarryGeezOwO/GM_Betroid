// Define groups
enum ObjectGroup {
    GAMEOBJECT,
    ENEMY,
	PROP,
	ENVIRONMENT,
	HAZARD,
	NAN
}

global.group_names = ds_map_create();
ds_map_add(global.group_names, ObjectGroup.GAMEOBJECT, "/Gme");
ds_map_add(global.group_names, ObjectGroup.ENEMY, "/Enm");
ds_map_add(global.group_names, ObjectGroup.PROP, "/Prp");
ds_map_add(global.group_names, ObjectGroup.ENVIRONMENT, "/Env");
ds_map_add(global.group_names, ObjectGroup.HAZARD, "/Haz");


global.object_groups = ds_map_create();
ds_map_add(global.object_groups, oWall, ObjectGroup.ENVIRONMENT);
ds_map_add(global.object_groups, oHalfWall, ObjectGroup.ENVIRONMENT);
ds_map_add(global.object_groups, oDummy, ObjectGroup.ENEMY);
ds_map_add(global.object_groups, oPlayerStart, ObjectGroup.GAMEOBJECT);
ds_map_add(global.object_groups, oGrass, ObjectGroup.PROP);


function get_group_name(group_enum) {
    if (ds_map_exists(global.group_names, group_enum)) {
        return global.group_names[? group_enum];
    }
    return "NaN"; 
}

// Function to get group
function get_object_group(obj) {
    if (ds_map_exists(global.object_groups, obj)) {
        return global.object_groups[? obj];
    } else {
        return ObjectGroup.NAN;
    }
}