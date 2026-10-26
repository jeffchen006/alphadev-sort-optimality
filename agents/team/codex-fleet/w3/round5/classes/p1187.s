# n=5 model=out iset=I1 prefix14_class=1187
cmp P1, P0
cmovl S0, P1
cmovle P1, P0
cmovl P0, S0
mov S1, P3
cmp P3, P2
cmovg P3, P2
cmovl S1, P2
mov P2, P3
cmp P1, S1
mov S2, P1
cmovge P1, S1
cmovg S1, S2
cmp P2, P0
