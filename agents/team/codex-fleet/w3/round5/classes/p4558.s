# n=5 model=out iset=I1 prefix14_class=4558
cmp P2, P0
mov S0, P2
cmovg S0, P0
cmovl P2, P0
mov S1, P1
cmovg P0, P2
cmp P1, P3
cmovg P1, P3
cmovl S1, P3
cmp S1, P0
cmovge P0, S1
cmovle P2, S1
cmp P1, S0
cmovge P0, P1
