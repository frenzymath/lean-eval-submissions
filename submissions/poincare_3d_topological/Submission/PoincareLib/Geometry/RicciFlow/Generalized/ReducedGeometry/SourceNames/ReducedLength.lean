import Submission.PoincareLib.Geometry.RicciFlow.ReducedGeometry.ReducedLength.Action.EnergyBound
import Submission.PoincareLib.Geometry.RicciFlow.ReducedGeometry.ReducedLength.Action.PositiveMomentumDerivative
import Submission.PoincareLib.Geometry.RicciFlow.ReducedGeometry.ReducedLength.Barrier.SecondDerivativeComparison
import Submission.PoincareLib.Geometry.RicciFlow.ReducedGeometry.ReducedLength.Barrier.ShiftedCostDifferential
import Submission.PoincareLib.Geometry.RicciFlow.ReducedGeometry.ReducedLength.Barrier.SmoothJoinCutoff
import Submission.PoincareLib.Geometry.RicciFlow.ReducedGeometry.ReducedLength.Calculus.LocalSmoothInverse
import Submission.PoincareLib.Geometry.RicciFlow.ReducedGeometry.ReducedLength.Calculus.ManifoldLocalInverse
import Submission.PoincareLib.Geometry.RicciFlow.ReducedGeometry.ReducedLength.Calculus.PathSpaceCalculus
import Submission.PoincareLib.Geometry.RicciFlow.ReducedGeometry.ReducedLength.Calculus.SmoothImplicit
import Submission.PoincareLib.Geometry.RicciFlow.ReducedGeometry.ReducedLength.Calculus.TriangularBijective
import Submission.PoincareLib.Geometry.RicciFlow.ReducedGeometry.ReducedLength.Coordinates.CoordinateCompatibility
import Submission.PoincareLib.Geometry.RicciFlow.ReducedGeometry.ReducedLength.Coordinates.CoordinateConnectionTime
import Submission.PoincareLib.Geometry.RicciFlow.ReducedGeometry.ReducedLength.Tensor.BasisContractions
import Submission.PoincareLib.Geometry.RicciFlow.ReducedGeometry.ReducedLength.Tensor.CoordinateConnectionBilinear
import Submission.PoincareLib.Geometry.RicciFlow.ReducedGeometry.ReducedLength.Tensor.FrameForms
import Submission.PoincareLib.Geometry.RicciFlow.ReducedGeometry.ReducedLength.Tensor.LocalCenteredHessian
import Submission.PoincareLib.Geometry.RicciFlow.ReducedGeometry.ReducedLength.Tensor.RicciContractions
import Submission.PoincareLib.Geometry.RicciFlow.ReducedGeometry.ReducedLength.Variation.Differential.CoordinateEulerLinearization
import Submission.PoincareLib.Geometry.RicciFlow.ReducedGeometry.ReducedLength.Variation.Differential.CoordinateJacobiCommutation
import Submission.PoincareLib.Geometry.RicciFlow.ReducedGeometry.ReducedLength.Variation.Differential.SecondDerivativeComposition
import Submission.PoincareLib.Geometry.RicciFlow.ReducedGeometry.ReducedLength.Variation.Differential.SecondOrderLinearization
import Submission.PoincareLib.Geometry.RicciFlow.ReducedGeometry.ReducedLength.Variation.Index.AdaptedIndexTrace
import Submission.PoincareLib.Geometry.RicciFlow.ReducedGeometry.ReducedLength.Variation.Initial.InitialVectorIdentification

/-! Source-name facade for the unchanged Mapher proof bodies. -/

namespace PoincareMT.Proofs.M09

export PoincareMT.ReducedLength
  (bilinear_square_basis_eq
   bilinear_trace_basis_eq
   chartVectorField
   coordinateConnectionBilinear
   coordinateConnectionBilinear_apply
   coordinateConnectionBilinear_contDiffOn
   coordinateConnection_pairing
   coordinateConnection_symm
   coordinateConnection_time_pairing
   coordinate_jacobi_commutation
   covariantRicci_direction_orthonormal_trace
   covariantRicci_divergence_trace_basis_eq
   curvature_index_smul
   curvature_orthonormal_index_trace
   exists_manifold_local_inverse
   exists_smoothJoinCutoff_deriv_bound
   exists_smooth_implicit
   exists_smooth_local_inverse
   fderiv_bilinear_symm
   hasDerivAt_variation_phase_of_ode
   hessian_centeredCoordinates_local
   lExponentialFamily_initialSlice_contMDiffAt
   lExponentialFamily_initial_velocity
   lExponentialFamily_squareSlice_contMDiffAt
   localMin_meetingMomentum_deriv_eq_zero
   localMin_secondDeriv_scaled_comparison
   mvfderiv_centeredChart_of_eventuallyEq
   pointwiseLinear
   pointwiseLinear_norm_le
   pointwiseOperator
   positiveMomentum_deriv_eq_zero
   regularizedCoordinatePhase
   regularizedCoordinatePhase_connection_pairing
   regularizedCoordinatePhase_covariant_linearized_pairing
   regularizedCoordinatePhase_smooth
   regularizedEnergy_abs_bound
   ricciDerivative_smul_first_third
   ricciDerivative_smul_last_two
   ricciOperator
   ricciOperator_orthonormal_square
   ricciOperator_pairing
   ricci_orthonormal_trace
   scalarCurvature_contMDiff
   scalarCurvature_mvfderiv_of_bianchi
   secondDeriv_comp
   shiftedCost_fderiv
   smoothJoinBlend
   smoothJoinBlend_hasDerivAt
   smoothJoinBlend_mem_convex
   smoothJoinCutoff
   smoothJoinCutoff_contDiff
   smoothJoinCutoff_mem
   smoothJoinCutoff_one
   smoothJoinCutoff_zero
   tensorBilinear
   tensorBilinear_apply
   timeDerivativePhase
   triangular_bijective_iff)

end PoincareMT.Proofs.M09
