# n=5 model=out iset=I1 prefix14_class=13920
mov S2, P2
cmp P2, P3
mov S1, P1
cmovl S2, P3
cmovle P3, P2
cmp P1, P0
cmovl P1, P0
cmovg S1, P0
cmp P1, S2
cmovge P2, S2
cmovge S2, P1
cmovge P1, P2
mov S0, P1
mov P0, S1
