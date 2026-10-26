# n=5 model=out iset=I1 prefix14_class=8598
mov S0, P3
cmp P1, P2
mov S2, P2
cmovl S2, P1
cmovl P1, P2
cmp P3, P0
cmovg S0, P0
cmovge P0, P3
cmp P0, P1
cmovle P2, P0
cmovle P0, P1
cmovl P1, P2
cmp S0, S2
cmovg P0, S0
