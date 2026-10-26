# n=5 model=out iset=I1 prefix14_class=8658
mov S0, P2
cmp S0, P0
cmovge P2, P0
cmovl S0, P0
cmp P1, P3
cmovle P0, P3
cmovle P3, P1
cmovl P1, P0
mov P0, S0
cmp P0, P1
cmovle P0, P1
cmovge S0, P1
cmp P3, P2
cmovg P1, P3
