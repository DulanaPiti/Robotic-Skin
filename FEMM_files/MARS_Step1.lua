showconsole()
clearconsole()

-- Create a new magnetic problem document (0 = magnetics)
newdocument(0) 

-- mi_probdef(frequency, units, type, precision, depth, minangle, acsolver)
-- frequency = 0 (DC current, no AC induction yet)
-- units = 'millimeters' (standard for our PCB and mechanical limits)
-- type = 'axi' (Axisymmetric)
mi_probdef(0, 'millimeters', 'axi', 1e-8, 0, 30)

-- Define the computational boundary (A half-circle for axisymmetric)
-- mi_drawarc(x1, y1, x2, y2, angle, maxseg)
mi_drawarc(0, -50, 0, 50, 180, 1) 

-- Draw the axis of symmetry directly on r = 0
mi_addsegment(0, -50, 0, 50)

-- Center the view
mi_zoomnatural()

print("Step 1 Complete: Axisymmetric workspace initialized.")