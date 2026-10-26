# n=5 model=out iset=I1 prefix14_class=5242
cmp P2, P1
cmovge S0, P2
mov S1, P3
cmovg P2, P1
cmovg P1, S0
cmp P0, S1
cmovl S1, P0
cmovl P0, P3
cmp S1, P2
cmovle S2, S1
cmovg S2, P2
mov P3, P0
cmovge P2, S1
mov S2, P2
