import KProto.D3k8I1.Mod0
import KProto.D3k8I1.Mod1
import KProto.D3k8I1.Mod2
import KProto.D3k8I1.Mod3
import KProto.D3k8I1.Mod4
import KProto.D3k8I1.Mod5
import KProto.D3k8I1.Mod6
import KProto.D3k8I1.Mod7
import KProto.D3k8I1.Mod8
import KProto.D3k8I1.Mod9
import KProto.D3k8I1.Mod10
import KProto.D3k8I1.Mod11
import KProto.D3k8I1.Mod12
import KProto.D3k8I1.Mod13
import KProto.D3k8I1.Mod14
import KProto.D3k8I1.Mod15
import KProto.D3k8I1.Mod16
import KProto.D3k8I1.Mod17
import KProto.D3k8I1.NMod0
import KProto.D3k8I1.NMod1
import LeanReflect.Ctx3
set_option maxRecDepth 100000
namespace KProto.D3k8I1
open LeanReflect KProto SortProof
theorem cert_all : (cert.toList M 3).all F = true := by
  simp only [cert, BT2.toList, List.all_append, List.all_cons, chunk0_ok, chunk1_ok, chunk2_ok, chunk3_ok, chunk4_ok, chunk5_ok, chunk6_ok, chunk7_ok, chunk8_ok, chunk9_ok, chunk10_ok, chunk11_ok, chunk12_ok, chunk13_ok, chunk14_ok, chunk15_ok, chunk16_ok, chunk17_ok, chunk18_ok, chunk19_ok, chunk20_ok, chunk21_ok, chunk22_ok, chunk23_ok, chunk24_ok, chunk25_ok, chunk26_ok, chunk27_ok, chunk28_ok, chunk29_ok, chunk30_ok, chunk31_ok, chunk32_ok, chunk33_ok, chunk34_ok, chunk35_ok, chunk36_ok, chunk37_ok, chunk38_ok, chunk39_ok, chunk40_ok, chunk41_ok, chunk42_ok, chunk43_ok, chunk44_ok, chunk45_ok, chunk46_ok, chunk47_ok, chunk48_ok, chunk49_ok, chunk50_ok, chunk51_ok, chunk52_ok, chunk53_ok, chunk54_ok, chunk55_ok, chunk56_ok, chunk57_ok, chunk58_ok, chunk59_ok, chunk60_ok, chunk61_ok, chunk62_ok, chunk63_ok, chunk64_ok, chunk65_ok, chunk66_ok, chunk67_ok, chunk68_ok, chunk69_ok, chunk70_ok, node0_ok, node1_ok, node2_ok, node3_ok, node4_ok, node5_ok, node6_ok, node7_ok, node8_ok, node9_ok, node10_ok, node11_ok, node12_ok, node13_ok, node14_ok, node15_ok, node16_ok, node17_ok, node18_ok, node19_ok, node20_ok, node21_ok, node22_ok, node23_ok, node24_ok, node25_ok, node26_ok, node27_ok, node28_ok, node29_ok, node30_ok, node31_ok, node32_ok, node33_ok, node34_ok, node35_ok, node36_ok, node37_ok, node38_ok, node39_ok, node40_ok, node41_ok, node42_ok, node43_ok, node44_ok, node45_ok, node46_ok, node47_ok, node48_ok, node49_ok, node50_ok, node51_ok, node52_ok, node53_ok, node54_ok, node55_ok, node56_ok, node57_ok, node58_ok, node59_ok, node60_ok, node61_ok, node62_ok, node63_ok, node64_ok, node65_ok, node66_ok, node67_ok, node68_ok, node69_ok, Bool.and_true, Bool.true_and]
/-- KERNEL-ONLY: no program of length ≤ 8 sorts 3 inputs in the relaxed RS model (I1, any registers). -/
theorem lower_bound_kernel : ∀ (p : SortProof.Program) (o : SortProof.Snap), p.length ≤ 8 → ¬ RelaxedSnap 3 p o :=
  fun p o hp => lower_bound_tree2 3 8 I1 ctxOK3 swap_I1 cert root_ok cert_all p o hp (fun i _ => condIn_I1 i)
theorem lower_bound_kernel_x86 : ∀ (p : SortProof.Program) (o : SortProof.Snap), p.length ≤ 8 → ¬ XSnap 3 p o :=
  fun p o hp hx => lower_bound_kernel p o hp (xsnap_to_relaxed (by decide) hx)
end KProto.D3k8I1
