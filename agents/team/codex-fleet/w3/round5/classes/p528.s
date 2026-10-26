# n=5 model=out iset=I1 prefix14_class=528
cmp P3, P1
mov S0, P3
cmovg P3, P1
mov S1, P2
cmovge P1, S0
cmp S1, P0
cmovge P2, P0
cmovg P0, S1
mov S1, P3
cmp P2, P3
cmovg P3, P2
cmovl S1, P2
cmovle P2, P3
cmp P1, P0
