# n=5 model=out iset=I1 prefix14_class=4040
cmp P1, P3
cmovge S1, P1
cmovge P1, P3
cmovg P3, S1
mov S2, P2
cmp P0, P2
cmovl P2, P0
mov S0, P2
cmovge S2, P0
cmp P1, P2
cmovle P2, P1
cmovg S0, P1
cmp P3, S2
mov P2, P3
