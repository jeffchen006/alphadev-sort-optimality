import KProto.D3k8I1G.Mod0
import KProto.D3k8I1G.Mod1
import KProto.D3k8I1G.Mod2
import KProto.D3k8I1G.Mod3
import KProto.D3k8I1G.Mod4
import KProto.D3k8I1G.Mod5
import KProto.D3k8I1G.Mod6
import KProto.D3k8I1G.Mod7
import KProto.D3k8I1G.Mod8
import KProto.D3k8I1G.Mod9
import KProto.D3k8I1G.Mod10
import KProto.D3k8I1G.Mod11
import KProto.D3k8I1G.Mod12
import KProto.D3k8I1G.Mod13
import KProto.D3k8I1G.Mod14
import KProto.D3k8I1G.Mod15
import KProto.D3k8I1G.Mod16
import KProto.D3k8I1G.Mod17
import KProto.D3k8I1G.Mod18
import KProto.D3k8I1G.Mod19
import KProto.D3k8I1G.Mod20
import KProto.D3k8I1G.Mod21
import KProto.D3k8I1G.Mod22
import KProto.D3k8I1G.Mod23
import KProto.D3k8I1G.Mod24
import KProto.D3k8I1G.Mod25
import KProto.D3k8I1G.Mod26
import KProto.D3k8I1G.Mod27
import KProto.D3k8I1G.Mod28
import KProto.D3k8I1G.Mod29
import KProto.D3k8I1G.Mod30
import KProto.D3k8I1G.Mod31
import KProto.D3k8I1G.NMod0
import KProto.D3k8I1G.NMod1
import KProto.D3k8I1G.NMod2
import KProto.D3k8I1G.NMod3
import KProto.D3k8I1G.NMod4
import KProto.D3k8I1G.NMod5
import KProto.D3k8I1G.NMod6
import KProto.D3k8I1G.NMod7
import LeanReflect.Ctx3
set_option maxRecDepth 100000
namespace KProto.D3k8I1G
open LeanReflect KProto SortProof
theorem cert_all : (cert.toList M 3).all F = true := by
  simp only [cert, BT2.toList, List.all_append, List.all_cons, chunk0_ok, chunk1_ok, chunk2_ok, chunk3_ok, chunk4_ok, chunk5_ok, chunk6_ok, chunk7_ok, chunk8_ok, chunk9_ok, chunk10_ok, chunk11_ok, chunk12_ok, chunk13_ok, chunk14_ok, chunk15_ok, chunk16_ok, chunk17_ok, chunk18_ok, chunk19_ok, chunk20_ok, chunk21_ok, chunk22_ok, chunk23_ok, chunk24_ok, chunk25_ok, chunk26_ok, chunk27_ok, chunk28_ok, chunk29_ok, chunk30_ok, chunk31_ok, node0_ok, node1_ok, node2_ok, node3_ok, node4_ok, node5_ok, node6_ok, node7_ok, node8_ok, node9_ok, node10_ok, node11_ok, node12_ok, node13_ok, node14_ok, node15_ok, node16_ok, node17_ok, node18_ok, node19_ok, node20_ok, node21_ok, node22_ok, node23_ok, node24_ok, node25_ok, node26_ok, node27_ok, node28_ok, node29_ok, node30_ok, Bool.and_true, Bool.true_and]
theorem setCtxOK : SetCtxOK (mkCtx 3) := ⟨by decide, by decide⟩
theorem groupOK : GroupOK (mkCtx 3) (group (mkCtx 3)) := ⟨by decide, by decide⟩
/-- KERNEL-ONLY: no program of length ≤ 8 sorts 3 inputs in the relaxed RS model (I1, any registers). -/
theorem lower_bound_kernel : ∀ (p : SortProof.Program) (o : SortProof.Snap), p.length ≤ 8 → ¬ RelaxedSnap 3 p o :=
  fun p o hp => lower_bound_treeG 3 8 I1 ctxOK3 setCtxOK groupOK swap_I1 cert root_ok cert_all p o hp (fun i _ => condIn_I1 i)
theorem lower_bound_kernel_x86 : ∀ (p : SortProof.Program) (o : SortProof.Snap), p.length ≤ 8 → ¬ XSnap 3 p o :=
  fun p o hp hx => lower_bound_kernel p o hp (xsnap_to_relaxed (by decide) hx)
end KProto.D3k8I1G
