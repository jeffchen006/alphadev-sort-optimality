# n=5 model=out iset=I1 prefix14_class=8024
mov S0, P1
cmp S0, P2
cmovl P1, P2
cmovge S0, P2
mov P2, P0
cmp P2, P3
cmovle P0, P3
cmovge P2, P3
cmp S0, P2
mov P3, S0
cmovg P3, P2
cmovg P2, S0
cmp P1, P0
cmovl P3, P1
