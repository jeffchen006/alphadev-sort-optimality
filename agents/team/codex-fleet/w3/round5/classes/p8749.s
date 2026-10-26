# n=5 model=out iset=I1 prefix14_class=8749
mov S0, P3
cmp P2, S0
cmovge P3, P2
cmovg P2, S0
mov S2, P1
cmp S2, P0
cmovl P1, P0
cmovle P0, S2
mov S1, P3
cmp P1, S1
cmovl S1, P1
cmovl P1, P3
cmp P2, P0
cmovle P1, P2
