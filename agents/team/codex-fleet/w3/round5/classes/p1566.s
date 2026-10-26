# n=5 model=out iset=I1 prefix14_class=1566
mov S1, P2
mov S2, P1
cmp P3, S1
cmovge S1, P3
cmovl P2, P3
cmp P0, P1
cmovg S2, P0
cmovle P1, P0
mov S0, S1
cmp P2, P1
mov P0, P2
cmovge P2, P1
cmovg P1, P0
cmp S2, S1
