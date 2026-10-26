# n=5 model=out iset=I1 prefix14_class=11963
cmp P2, P3
mov S0, P0
cmovge S2, P2
cmovg P2, P3
cmovge P3, S2
cmp S0, P1
cmovg S0, P1
cmovg P1, P0
mov S1, P1
cmp P3, P1
cmovl P1, P3
cmovge S1, P3
cmp P2, S0
cmovle P0, P2
