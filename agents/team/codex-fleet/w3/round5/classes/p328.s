# n=5 model=out iset=I1 prefix14_class=328
cmp P2, P3
mov S1, P2
cmovge P2, P3
cmovge P3, S1
mov S0, P0
cmp P1, S0
cmovg P0, P1
cmovl S0, P1
mov S2, P3
cmovg P1, S0
cmp P2, P1
cmovl P1, P2
cmovle P2, S0
mov P1, P2
