# n=5 model=out iset=I1 prefix14_class=852
cmp P0, P3
cmovl S2, P3
cmovge S2, P0
mov S1, P1
cmovge P0, P3
cmp P1, P2
cmovg S1, P2
mov S0, S1
cmovg P2, P1
mov P3, P2
cmp S2, P3
cmovg P3, S2
cmovge S2, P2
cmovle P2, S2
