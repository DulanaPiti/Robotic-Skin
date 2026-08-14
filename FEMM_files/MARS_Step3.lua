showconsole()
clearconsole()
newdocument(0) 
mi_probdef(0, 'millimeters', 'axi', 1e-8, 0, 30)

-- STEP 1: Computational Boundary
mi_drawarc(0, -50, 0, 50, 180, 1) 
mi_addsegment(0, -50, 0, 50)

-- STEP 2: Parameters and Geometries
r_inner = 5        
r_outer = 15       
coil_height = 10   
gap = 2            
skin_thickness = 3 
skin_radius = 20   

mi_drawrectangle(r_inner, 0, r_outer, coil_height)
mi_addblocklabel((r_inner + r_outer)/2, coil_height/2) 

skin_bottom = coil_height + gap
skin_top = skin_bottom + skin_thickness
mi_drawrectangle(0, skin_bottom, skin_radius, skin_top)
mi_addblocklabel(skin_radius/2, (skin_bottom + skin_top)/2)

mi_addblocklabel(10, 30) 

-- --- NEW CODE FOR STEP 3 ---

-- 1. Create Materials (Name, mu_x, mu_y, H_c, J, Cduct, Lam_d, Phi_hmax, lam_fill, LamType, Phi_hx, Phi_hy)
mi_addmaterial('Air', 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0)
mi_addmaterial('Copper', 1, 1, 0, 0, 58, 0, 0, 1, 0, 0, 0)
mi_addmaterial('MRE_Skin', 1.5, 1.5, 0, 0, 0, 0, 0, 1, 0, 0, 0)

-- 2. Define the Coil Circuit (Name, Current in Amps, Type: 1 = Series)
mi_addcircprop('Coil_Current', 1.0, 1)

-- 3. Assign Properties to the Block Labels
-- Format: mi_setblockprop('BlockName', automesh, meshsize, 'CircuitName', magdirection, group, turns)

-- Assign Air
mi_selectlabel(10, 30)
mi_setblockprop('Air', 1, 1, '<None>', 0, 0, 0)
mi_clearselected()

-- Assign Skin
mi_selectlabel(skin_radius/2, (skin_bottom + skin_top)/2)
mi_setblockprop('MRE_Skin', 1, 1, '<None>', 0, 0, 0)
mi_clearselected()

-- Assign Coil (Linking to Circuit, 300 turns)
mi_selectlabel((r_inner + r_outer)/2, coil_height/2)
mi_setblockprop('Copper', 1, 1, 'Coil_Current', 0, 0, 300)
mi_clearselected()

-- Apply boundary conditions to the outer edge (forcing vector potential A=0 at infinity)
mi_selectarcsegment(0, 50)
mi_setarcsegmentprop(1, "A=0", 0, 0)
mi_clearselected()

mi_zoomnatural()
print("Step 3 Complete: Materials assigned and boundary conditions set.")