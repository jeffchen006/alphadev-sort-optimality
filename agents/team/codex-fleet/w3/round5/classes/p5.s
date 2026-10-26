# n=5 model=out iset=I1 prefix14_class=5
mov S1, P0
cmp P1, P0
cmovl P0, P1
cmovle P1, S1
cmp P3, P2
cmovl S2, P3
cmovge S2, P2
cmovge P2, P3
cmp P0, S2
cmovg S0, P0
cmovg P0, S2
cmovg S2, S0
cmovle S0, S2
mov P3, P2
