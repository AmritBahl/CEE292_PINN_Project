# Mechanical subApp for the weakly coupled thermo-elastic analysis
# solves:
# sigma = C: (eps - alpha * (T - T0)I) = lambda tr(eps) I + 2 mu eps - alpha (3 lambda + 2 mu) (T - T0) I
# All units in SI

# inputs
L = 5
H = 0.3
T_ambient = 298

[GlobalParams]
    displacements = 'disp_x disp_y'
[]

[Mesh]
    [beam]
        type = GeneratedMeshGenerator
        dim = 2
        xmax = ${L}
        ymax = ${H}
        nx = 100
        ny = 10
        elem_type = QUAD9
    []
[]

[AuxVariables]
    [T] # received from the thermal file
        order = FIRST
        family = LAGRANGE
        initial_condition = ${T_ambient}
    []
[]

[Physics/SolidMechanics/QuasiStatic]
    [all]
        strain = SMALL
        incremental = false
        add_variables = true
        eigenstrain_names = 'thermal_eigenstrain'
        generate_output = 'stress_xx stress_yy vonmises_stress'
    []
[]

[Materials]
    [elasticity]
        type = ComputeIsotropicElasticityTensor
        youngs_modulus = 50e3
        poissons_ratio = 0.2
    []
    [stress]
        type = ComputeLinearElasticStress
    []
    [thermal_expansion]
        type = ComputeThermalExpansionEigenstrain
        temperature = T
        thermal_expansion_coeff = 1e-5
        stress_free_temperature = ${T_ambient}
        eigenstrain_name = thermal_eigenstrain
    []
[]

[BCs]
    [left_x]
        type = DirichletBC
        variable = disp_x
        boundary = left
        value = 0
    []
    [left_y]
        type = DirichletBC
        variable = disp_y
        boundary = left
        value = 0
    []
    [right_x]
        type = DirichletBC
        variable = disp_x
        boundary = right
        value = 0
    []
    [right_y]
        type = DirichletBC
        variable = disp_y
        boundary = right
        value = 0
    []
[]

[Executioner]
    type = Steady
    solve_type = NEWTON
    petsc_options_iname = '-pc_type'
    petsc_options_value = 'lu'
[]

[Outputs]
    exodus = true
[]
