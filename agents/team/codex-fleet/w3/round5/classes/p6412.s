# n=5 model=out iset=I1 prefix14_class=6412
mov S1, P0
cmp P2, P3
cmovge S0, P2
cmovge P2, P3
cmovge P3, S0
cmp P1, P0
cmovg S1, P1
cmovle P0, P1
mov P1, S1
cmp P3, S1
cmovl P1, P3
cmovg S1, P3
mov S2, P1
cmp P0, P2
