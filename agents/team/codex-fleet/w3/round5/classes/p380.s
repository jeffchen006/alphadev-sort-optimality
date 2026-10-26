# n=5 model=out iset=I1 prefix14_class=380
mov S0, P3
mov S2, P2
cmp S2, P1
cmovge P2, P1
cmovl S2, P1
cmp P3, P0
cmovg P3, P0
cmovl S0, P0
cmovg P0, S0
cmp P2, P3
mov P1, P3
cmovl P1, P2
cmovle P2, P3
cmp S2, S0
