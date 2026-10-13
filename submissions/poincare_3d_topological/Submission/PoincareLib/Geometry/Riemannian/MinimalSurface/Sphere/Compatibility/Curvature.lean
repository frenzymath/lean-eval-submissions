import Submission.PoincareLib.Geometry.RicciFlow.Curvature.Calculus.Fields.ConnectionScalar
import Submission.PoincareLib.Geometry.RicciFlow.Curvature.Calculus.Fields.ScalarChainRule
import Submission.PoincareLib.Geometry.RicciFlow.Curvature.Calculus.Identities.CurvatureAlgebra
import Submission.PoincareLib.Geometry.RicciFlow.Curvature.Calculus.Identities.CurvatureSymmetries
import Submission.PoincareLib.Geometry.RicciFlow.Curvature.Estimates.QuadraticRicci
import Submission.PoincareLib.Geometry.RicciFlow.Curvature.Estimates.Shi.Paths.Energy
import Submission.PoincareLib.Geometry.RicciFlow.Curvature.Evolution.Scalar.Coefficients

/-! Source-name facade for the preserved Mapher area and width proofs. -/

namespace PoincareMT.M04
export PoincareMT.RicciFlowAnalysis (
  contMDiffAt_directional_derivative
  continuousOn_flow_ricciNormSq
  continuous_pathSpeed
  curvatureTensor_swap_first
  curvatureTensor_swap_last
  pathELength_eq_ofReal_integral_pathSpeed
  pathSpeed
  scalarGradientSq
  tensorEvaluation_sq_le_tensorNorm)
end PoincareMT.M04
