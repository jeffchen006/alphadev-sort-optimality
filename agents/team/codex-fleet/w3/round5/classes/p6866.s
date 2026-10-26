# n=5 model=out iset=I1 prefix14_class=6866
cmp P0, P1
mov S0, P3
cmovle S1, P1
cmovl P1, P0
cmovle P0, S1
cmp S0, P2
mov S2, P0
cmovl S0, P2
cmovle P2, P3
cmp S0, P0
cmovge P0, S0
mov P0, P2
cmovl S2, S0
cmp P1, P0
