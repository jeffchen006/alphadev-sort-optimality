# n=5 model=out iset=I1 prefix14_class=517
cmp P3, P2
mov S2, P1
mov S1, P3
cmovge S1, P2
cmovg P2, P3
cmp S2, P0
cmovg S2, P0
cmovge P0, P1
mov S0, P2
mov P1, S1
cmp S2, P1
cmovl S1, S2
cmovg P1, S2
cmovle S2, P1
