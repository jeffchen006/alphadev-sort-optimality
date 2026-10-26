# n=5 model=out iset=I1 prefix14_class=6309
mov S2, P0
cmp P2, P3
cmovge S1, P3
cmovge P3, P2
cmovle S1, P2
cmp P1, S2
cmovl S2, P1
cmovg P0, P1
mov S0, P0
cmp P3, S0
cmovge P0, P3
cmovl S0, P3
mov P3, S1
cmp S2, S1
