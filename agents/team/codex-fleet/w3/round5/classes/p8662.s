# n=5 model=out iset=I1 prefix14_class=8662
cmp P1, P0
cmovge S2, P0
cmovge P0, P1
mov S0, P2
cmovge P1, S2
cmp P3, S0
cmovl P2, P3
cmovle P3, S0
mov S0, P0
cmp S0, P3
cmovle P0, P3
cmovg S0, P3
mov P3, P1
cmp P2, P1
