# n=5 model=out iset=I1 prefix14_class=12902
mov S2, P3
cmp P1, S2
cmovg P3, P1
cmovge P1, S2
mov S1, P0
cmp P0, P2
cmovg S1, P2
cmovle P0, P2
cmp S1, P1
cmovle P2, P1
cmovl P1, S1
mov S0, P0
cmovl S1, P2
cmp S0, P3
