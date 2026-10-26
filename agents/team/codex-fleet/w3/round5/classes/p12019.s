# n=5 model=out iset=I1 prefix14_class=12019
cmp P0, P1
mov S1, P0
cmovg P0, P1
cmovge P1, S1
mov S1, P3
cmp P3, P2
mov S0, P1
cmovl P3, P2
cmovg S1, P2
cmp S1, P0
cmovle P2, S1
cmovl S1, P0
cmovle P0, P2
mov S2, S1
