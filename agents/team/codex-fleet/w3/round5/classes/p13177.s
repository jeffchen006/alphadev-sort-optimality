# n=5 model=out iset=I1 prefix14_class=13177
cmp P2, P0
cmovle S2, P2
mov S0, P1
cmovle P2, P0
cmovl P0, S2
cmp P3, P1
cmovge P1, P3
cmovl S0, P3
cmp P0, S0
mov S1, S0
cmovle S0, P0
cmovg S1, P0
cmp P2, P1
cmovge S0, P1
