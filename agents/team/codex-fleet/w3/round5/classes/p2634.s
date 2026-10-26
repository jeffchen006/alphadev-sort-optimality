# n=5 model=out iset=I1 prefix14_class=2634
mov S2, P0
cmp P1, P2
cmovg S0, P2
cmovge P2, P1
cmovg P1, S0
cmp P3, P0
cmovl P0, P3
cmovg S2, P3
mov S1, P2
cmp S2, S1
cmovle P2, S2
cmovl S2, S1
mov S1, P0
cmp P1, P0
