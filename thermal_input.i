# Thermal input file for the linear thermo-elasticity problem
# thermal problem (SS): div(k grad T) = 0
# All units in SI

# inputs
L = 5
H = 0.3
T_ambient = 298

[Mesh]
    [beam]
        type = GeneratedMeshGenerator
        dim = 2
        xmax = ${L}
        ymax = ${H}
        nx = 100
        ny = 10
    []
[]

[Variables]
    [T]
        order = FIRST
        family = LAGRANGE
    []
[]

# IC not needed as we are solving a SS problem

[Kernels]
    [conduction] # -div(k(T) grad T) 
        type = HeatConduction
        variable = T
    []
[]

[Materials]
    [thermal]
        type = HeatConductionMaterial
        specific_heat = 466 # J/(kg K), not requied for this SS problem
        thermal_conductivity = 50 # W/(m K)
    []
[]

[BCs]
    [t_left]
        type = DirichletBC
        variable = T
        value = ${T_ambient}
        boundary = 'left'
    []
    [t_right]
        type = DirichletBC
        variable = T
        value = ${T_ambient}
        boundary = 'right'
    []
    [t_top]
        type = DirichletBC
        variable = T
        value = ${T_ambient}
        boundary = 'top'
    []
    [t_bottom]
        type = DirichletBC
        variable = T
        value = '${fparse T_ambient + 50}'
        boundary = 'bottom'
    []
[]

[Executioner]
    type = Steady
[]

[Outputs]
    exodus = true
[]

[MultiApps]
    [mech]
        type = FullSolveMultiApp
        input_files = mechanical_subApp.i
        execute_on = 'TIMESTEP_END'
    []
[]

[Transfers]
    [T_to_mech]
        type = MultiAppGeneralFieldShapeEvaluationTransfer
        to_multi_app = mech
        source_variable = T
        variable = T
        execute_on = 'TIMESTEP_END'
    []
[]
