# n=5 model=out iset=I1 prefix14_class=11816
mov S1, P3
cmp S1, P0
cmovge P3, P0
mov S0, P3
cmovl S1, P0
mov S2, P1
cmp S2, P2
cmovl P1, P2
cmovle P2, S2
cmp P1, S1
cmovg S2, S1
cmovg S1, P1
cmovg P1, S2
cmp P3, P2
