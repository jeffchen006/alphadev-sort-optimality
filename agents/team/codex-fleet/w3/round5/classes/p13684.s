# n=5 model=out iset=I1 prefix14_class=13684
mov S1, P2
cmp S1, P1
mov S0, P3
cmovle P2, P1
cmovg S1, P1
cmp S0, P0
cmovl P3, P0
cmovge S0, P0
cmp P2, P3
cmovge P0, P3
cmovge P3, P2
cmovge P2, P0
cmp S0, S1
mov P1, P2
