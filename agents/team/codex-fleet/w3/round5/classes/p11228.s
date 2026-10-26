# n=5 model=out iset=I1 prefix14_class=11228
cmp P2, P1
mov S0, P1
cmovg S0, P2
mov S1, P3
cmovl P1, P2
cmp S1, P0
cmovg P3, P0
cmovge P0, S1
cmp P0, S0
cmovle P2, P0
cmovle P0, S0
cmovl S0, P2
cmp P3, P1
cmovge P2, S0
