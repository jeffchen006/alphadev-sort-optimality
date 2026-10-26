# n=5 model=out iset=I1 prefix14_class=4666
mov S1, P1
cmp P0, P3
mov S0, P3
cmovg P3, P0
cmovge P0, S0
cmp P2, P1
cmovle P1, P2
mov S2, P1
cmovl P2, S1
cmp P2, P3
cmovg S0, P3
cmovg P3, P2
cmovg P2, S0
cmp P1, P0
