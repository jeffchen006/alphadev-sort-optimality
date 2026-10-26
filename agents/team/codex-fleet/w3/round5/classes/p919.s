# n=5 model=out iset=I1 prefix14_class=919
cmp P3, P2
cmovge S0, P3
cmovl S0, P2
mov S1, S0
cmovle P2, P3
cmp P0, P1
cmovl S2, P0
cmovge S2, P1
cmovge P1, P0
cmp P1, S0
mov P3, S2
cmovle S0, P1
cmovge S1, P1
cmovg P1, S0
