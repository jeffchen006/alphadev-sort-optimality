# n=5 model=out iset=I1 prefix14_class=2787
cmp P2, P3
mov S1, P0
cmovle S2, P3
cmovg S2, P2
cmovg P2, P3
mov S0, S2
cmp S1, P1
cmovl S1, P1
cmovge P0, P1
cmp S0, S1
cmovge S2, S1
mov P1, S2
cmovle S0, S1
cmp P0, P2
