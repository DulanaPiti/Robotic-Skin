showconsole()
clearconsole()
newdocument(0) 
mi_probdef(0, 'millimeters', 'axi', 1e-8, 0, 30)

-- STEP 1 & 2: Boundary and Geometries
mi_drawarc(0, -50, 0, 50, 180, 1) 
mi_addsegment(0, -50, 0, 50)

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

-- STEP 3: Materials and Boundary Conditions
mi_addmaterial('Air', 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0)
mi_addmaterial('Copper', 1, 1, 0, 0, 58, 0, 0, 1, 0, 0, 0)
mi_addmaterial('MRE_Skin', 1.5, 1.5, 0, 0, 0, 0, 0, 1, 0, 0, 0)
mi_addcircprop('Coil_Current', 0.0, 1) -- Initialized at 0A

mi_selectlabel(10, 30)
mi_setblockprop('Air', 1, 1, '<None>', 0, 0, 0)
mi_clearselected()

mi_selectlabel(skin_radius/2, (skin_bottom + skin_top)/2)
mi_setblockprop('MRE_Skin', 1, 1, '<None>', 0, 0, 0)
mi_clearselected()

mi_selectlabel((r_inner + r_outer)/2, coil_height/2)
mi_setblockprop('Copper', 1, 1, 'Coil_Current', 0, 0, 300)
mi_clearselected()

mi_selectarcsegment(0, 50)
mi_setarcsegmentprop(1, "A=0", 0, 0)
mi_clearselected()

mi_zoomnatural()
mi_saveas('MARS_temp.fem') -- Must save before meshing

-- --- NEW CODE FOR STEP 4: SWEEP AND ANALYZE ---

-- Open a CSV file for writing the output data
outfile = openfile("MARS_Force_Data.csv", "w")
write(outfile, "Current(A), Z_Force(N)\n")

print("Starting current sweep...")

-- Loop from 0.5A to 3.0A in steps of 0.5A
for current = 0.5, 3.0, 0.5 do
    
    -- Update the circuit current
    mi_modifycircprop('Coil_Current', 1, current)
    
    -- Mesh and Analyze the problem
    mi_analyze()
    
    -- Load the solved results into the post-processor
    mi_loadsolution()
    
    -- Select the MRE Skin block in the post-processor
    mo_selectblock(skin_radius/2, (skin_bottom + skin_top)/2)
    
    -- Calculate Block Integral 19: z-directed Maxwell Stress Tensor Force
    fz = mo_blockintegral(19)
    mo_clearblock()
    
    -- Write to CSV and console
    write(outfile, current .. ", " .. fz .. "\n")
    print("Current: " .. current .. " A | Force: " .. fz .. " N")
    
    -- Close the post-processor window for the next iteration
    mo_close()
end

closefile(outfile)
print("Phase 1 Complete. Data saved to MARS_Force_Data.csv.")