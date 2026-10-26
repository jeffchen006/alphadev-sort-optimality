# n=5 model=out iset=I1 prefix14_class=8845
cmp P0, P3
cmovg S2, P0
mov S1, P2
cmovge P0, P3
cmovg P3, S2
cmp P1, S1
cmovle P2, P1
cmovge S1, P1
cmp P3, S1
cmovl S0, S1
cmovge S0, P3
cmovle S1, P3
mov S0, P0
cmp S0, P2
