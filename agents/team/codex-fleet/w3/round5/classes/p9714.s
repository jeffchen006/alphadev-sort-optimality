# n=5 model=out iset=I1 prefix14_class=9714
cmp P1, P3
cmovge S1, P3
cmovg P3, P1
cmovge P1, S1
mov S0, P2
cmp P0, P2
mov S2, P3
cmovl P2, P0
cmovge S0, P0
cmp S0, P3
cmovg S2, S0
cmovle P3, S0
mov P0, P1
cmp P1, P2
