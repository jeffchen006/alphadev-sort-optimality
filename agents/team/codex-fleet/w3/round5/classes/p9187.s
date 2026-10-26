# n=5 model=out iset=I1 prefix14_class=9187
mov S1, P0
mov S0, P3
cmp P2, P3
cmovl P3, P2
cmovg S0, P2
cmp P1, S1
cmovl P0, P1
cmovle P1, S1
cmp P3, P0
cmovge S2, P3
cmovge P3, P0
cmovg P0, S2
cmp P1, S0
mov P2, S0
