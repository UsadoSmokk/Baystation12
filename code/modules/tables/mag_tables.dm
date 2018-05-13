/obj/structure/table/mag
	name = "Magnetic Table"
	desc = "It is simple magnetic table. Good for merchants."
	icon = 'icons/mag_tables.dmi'
	icon_state = "magnetic_table_disabled"
	var/icon_state_open = "magnetic_table_disabled"
	var/icon_state_closed = "magnetic_table_enabled"
	can_plate = 0
	can_reinforce = 0
	flipped = -1
	var/locked = 0

/obj/structure/table/mag/New()
	..()
	verbs -= /obj/structure/table/verb/do_flip
	verbs -= /obj/structure/table/proc/do_put
	verbs += /obj/structure/table/mag/verb/lock

/obj/structure/table/mag/Initialize()
	. = ..()
	maxhealth = 20
	health = 20


/obj/structure/table/mag/update_icon()
	if (locked)
		icon_state = icon_state_closed
	else
		icon_state = icon_state_open
	return

/obj/structure/table/mag/can_connect()
	return FALSE

/obj/structure/table/mag/take_damage(amount)
	..()
	if(health <= 10 && locked)
		toggle_lock()


/obj/structure/table/mag/Destroy()
	if(locked)
		toggle_lock()
	..()

/obj/structure/table/mag/break_to_parts()
	if(locked)
		toggle_lock()
	..()

/obj/structure/table/mag/verb/lock()
	set name = "Toggle magTable lock"
	set desc = "..."
	set category = "Object"
	set src in oview(1)

	if (!can_touch(usr) || ismouse(usr))
		return

	toggle_lock()

	if(locked)
		usr.visible_message("<span class='warning'>[usr] locks [src]!</span>")
	else
		usr.visible_message("<span class='warning'>[usr] unlocks [src]!</span>")


/obj/structure/table/mag/proc/toggle_lock()

	if(health <= 10 && !locked)
		return

	if(anchored == 0)
		to_chat(user, "<span class='warning'>You need to secure the table first!</span>")
		return

	locked = !locked

	update_icon()

	for (var/obj/item/I in get_turf(src))
		I.anchored = locked

	playsound(src,'sound/machines/ding.ogg',100,1)

	return
