# n=5 model=out iset=I1 prefix14_class=12548
cmp P3, P2
cmovl S2, P3
cmovle P3, P2
cmovl P2, S2
mov S0, P2
cmp P1, P0
cmovg S1, P1
cmovge P1, P0
cmovg P0, S1
cmp P1, P2
cmovg P2, P1
mov S2, P2
cmovg P1, S0
cmp P0, P3
