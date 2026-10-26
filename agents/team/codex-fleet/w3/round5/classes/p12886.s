# n=5 model=out iset=I1 prefix14_class=12886
cmp P1, P2
cmovge S0, P1
cmovge P1, P2
cmovle S0, P2
mov S2, S0
cmp P3, P0
cmovle P2, P0
cmovl P0, P3
cmovl P3, P2
mov S1, P1
cmp P1, P0
cmovle P1, P0
cmovg S1, P0
mov P0, P1
