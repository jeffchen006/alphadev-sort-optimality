# n=5 model=out iset=I1 prefix14_class=5403
mov S2, P2
cmp P0, S2
cmovg S2, P0
cmovg P0, P2
mov S0, P3
cmp P3, P1
cmovl S0, P1
cmovle P1, P3
cmp P1, P0
cmovg P3, P1
cmovge P1, P0
cmovg P0, P3
cmp S0, S2
cmovl P3, S2
