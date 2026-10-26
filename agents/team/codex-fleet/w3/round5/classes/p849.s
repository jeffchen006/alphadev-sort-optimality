# n=5 model=out iset=I1 prefix14_class=849
cmp P0, P3
cmovle S1, P3
mov S2, P1
cmovge S1, P0
cmovg P0, P3
cmp S2, P2
cmovge S2, P2
cmovg P2, P1
mov P3, P2
cmp S1, P2
cmovge P2, S1
cmovg S1, P3
cmp P0, S2
cmovge S0, P0
