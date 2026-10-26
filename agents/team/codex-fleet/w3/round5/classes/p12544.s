# n=5 model=out iset=I1 prefix14_class=12544
cmp P3, P2
mov S2, P3
cmovle P3, P2
cmovl P2, S2
mov S1, P2
cmp P1, P0
cmovg S0, P1
cmovge P1, P0
cmovg P0, S0
cmp P1, S1
cmovg P2, P1
cmovge P1, S1
cmp P3, P0
cmovle P1, P3
