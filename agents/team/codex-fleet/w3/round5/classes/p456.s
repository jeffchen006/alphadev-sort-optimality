# n=5 model=out iset=I1 prefix14_class=456
cmp P3, P1
mov S1, P1
cmovg S1, P3
cmovl P1, P3
cmp P2, P0
cmovge S2, P2
cmovg P2, P0
cmovge P0, S2
mov S2, P1
mov S0, S1
cmp P2, P1
cmovl P1, P2
cmovle P2, S2
mov P1, P2
