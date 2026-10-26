# n=5 model=out iset=I1 prefix14_class=8991
mov S0, P2
cmp P1, P3
cmovg S1, P3
cmovg P3, P1
cmovg P1, S1
cmp P2, P0
cmovle P2, P0
cmovg S0, P0
cmp P3, P2
cmovge P0, P2
cmovge P2, P3
cmovl P0, P3
mov S2, P0
cmp P1, S0
