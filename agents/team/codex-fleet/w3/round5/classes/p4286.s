# n=5 model=out iset=I1 prefix14_class=4286
mov S0, P1
cmp S0, P0
cmovl S0, P0
cmovge P1, P0
cmp P2, P3
cmovle P0, P2
cmovl P2, P3
cmovg P0, P3
cmp P1, P0
mov P3, P1
cmovle P3, P0
cmovl P0, P1
cmp P2, S0
mov P0, P2
