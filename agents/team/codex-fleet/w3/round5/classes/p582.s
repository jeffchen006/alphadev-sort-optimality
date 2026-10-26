# n=5 model=out iset=I1 prefix14_class=582
cmp P3, P0
cmovge S1, P3
mov S0, P2
cmovg P3, P0
cmovl S1, P0
cmp S0, P1
cmovg S0, P1
cmovge P1, P2
mov P0, S1
cmp P1, S1
mov S2, S0
cmovg P0, P1
cmovle S1, P1
cmp P3, S2
