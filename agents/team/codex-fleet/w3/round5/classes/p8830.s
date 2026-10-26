# n=5 model=out iset=I1 prefix14_class=8830
cmp P1, P3
cmovge S2, P1
cmovl S2, P3
cmovge P1, P3
mov P3, P2
cmp P0, P3
cmovle P2, P0
cmovge P3, P0
cmp P3, S2
mov S1, P1
cmovge P0, P3
cmovge P3, S2
mov S0, P3
cmovg S2, P0
