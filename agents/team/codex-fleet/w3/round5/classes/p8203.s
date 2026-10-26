# n=5 model=out iset=I1 prefix14_class=8203
cmp P1, P2
mov S0, P1
cmovl P1, P2
cmovge S0, P2
mov P2, P3
cmp P0, P3
cmovl P2, P0
cmovle P0, P3
mov P3, P2
cmp S0, P2
cmovge P3, S0
cmovg S0, P2
mov S0, P1
cmp S0, P0
