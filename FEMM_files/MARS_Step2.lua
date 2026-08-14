showconsole()
clearconsole()
newdocument(0) 
mi_probdef(0, 'millimeters', 'axi', 1e-8, 0, 30)

-- 1. Computational Boundary
mi_drawarc(0, -50, 0, 50, 180, 1) 
mi_addsegment(0, -50, 0, 50)

-- 2. Define Parameters (in millimeters)
r_inner = 5        -- Core radius of the coil
r_outer = 15       -- Outer radius of the coil
coil_height = 10   -- Vertical height of the coil
gap = 2            -- Air gap between coil and skin
skin_thickness = 3 -- Thickness of the MRE skin
skin_radius = 20   -- Radial extent of the skin

-- 3. Draw the Coil Cross-Section
mi_drawrectangle(r_inner, 0, r_outer, coil_height)
-- Place a block label precisely in the center of the coil rectangle
mi_addblocklabel((r_inner + r_outer)/2, coil_height/2) 

-- 4. Draw the MRE Skin
skin_bottom = coil_height + gap
skin_top = skin_bottom + skin_thickness
mi_drawrectangle(0, skin_bottom, skin_radius, skin_top)
-- Place a block label in the center of the skin rectangle
mi_addblocklabel(skin_radius/2, (skin_bottom + skin_top)/2)

-- 5. Add a Block Label for the surrounding Air
-- Placed outside the hardware but inside the boundary
mi_addblocklabel(10, 30) 

mi_zoomnatural()
print("Step 2 Complete: Geometries and block labels generated.")