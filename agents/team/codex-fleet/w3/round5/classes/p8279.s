# n=5 model=out iset=I1 prefix14_class=8279
cmp P3, P0
mov S1, P0
cmovl P0, P3
cmovl P3, S1
cmp P2, P1
mov S2, P1
cmovle S2, P2
cmovge P1, P2
cmp P0, S2
cmovge S0, P0
cmovge P0, S2
cmovg S2, S0
mov P0, P3
cmp P1, P0
