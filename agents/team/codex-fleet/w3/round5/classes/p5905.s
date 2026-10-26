# n=5 model=out iset=I1 prefix14_class=5905
cmp P1, P0
mov S0, P1
cmovle S0, P0
cmovge P1, P0
cmp P2, P3
cmovge S2, P3
cmovg P3, P2
cmovge P2, S2
cmp P3, S0
cmovle S1, P3
mov P0, P2
cmovle P3, S0
cmovl S0, S1
cmp P0, P1
