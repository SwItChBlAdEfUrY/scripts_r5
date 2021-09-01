untyped

global function OnWeaponPrimaryAttack_custom_physgun
global function Physgun_Init

#if SERVER
global function OnWeaponNpcPrimaryAttack_custom_physgun
#endif // #if SERVER

entity m_hObject
bool m_active = false


void function Physgun_Init()
{
	#if SERVER && R5DEV

	#endif
}

var function OnWeaponPrimaryAttack_custom_physgun( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	return DoPhysgunFire( attackParams, false, weapon )
}

#if SERVER
var function OnWeaponNpcPrimaryAttack_custom_physgun( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	return DoPhysgunFire( attackParams, true, weapon )
}
#endif // #if SERVER

#if SERVER
void function AttachObject(entity object, vector start, vector end, float distance)
{
    //h_Objext = object

}
#endif // #if SERVER

#if SERVER
void function DetachObject()
{

}
#endif // #if SERVER

#if SERVER
void function EffectCreate(entity weapon, bool isServer)
{
    EffectUpdate(weapon, isServer)
	m_active = true

}
#endif // #if SERVER

#if SERVER
void function EffectUpdate(entity weapon,bool isServer)
{
    vector start
    vector angles
    vector forward
    vector right
    TraceResults tr

    entity owner = weapon.GetWeaponOwner()
    if(!IsValid(owner)){
        return
    }

    //vm check goes here

    angles = owner.GetAngles()
    forward = AnglesToForward(angles)
    right = AnglesToRight(angles)

    start = owner.EyePosition()
    vector end = start + forward * 4096

    tr = TraceLine( start, end, owner, TRACE_MASK_SHOT, TRACE_COLLISION_GROUP_NONE )
    end = tr.endPos
    float distance = tr.fraction * 4096
    if ( tr.fraction != 1 ){

        // too close to the player, drop object
        if(distance < 36){
            DetachObject()
            return
        }
    }

    if(m_hObject == null && tr.hitEnt.GetClassName() != "worldspawn"){
        entity pEntity = tr.hitEnt
        //missing damage stuff

        AttachObject(pEntity, start, tr.endPos, distance)
        m_lastYaw = owner.EyeAngles().y
    }



    /**
    if(par && par.GetClassName() == "prop_physics")
    **/


}
#endif // #if SERVER


int function DoPhysgunFire( WeaponPrimaryAttackParams attackParams, bool isServer, entity weapon )
{

    if(!m_active){
        EffectCreate(weapon);
    }
    else{
        EffectUpdate(weapon);
    }

    return 1
}


