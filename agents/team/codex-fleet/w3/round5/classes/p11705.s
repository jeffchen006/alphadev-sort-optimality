# n=5 model=out iset=I1 prefix14_class=11705
cmp P2, P0
cmovl S0, P2
mov S1, P3
cmovl P2, P0
cmovl P0, S0
cmp P1, P3
mov S2, P0
cmovg S1, P1
cmovle P3, P1
cmp P2, S1
cmovge P1, P2
cmovle P1, S1
cmovg P2, S1
cmovl S1, P2
