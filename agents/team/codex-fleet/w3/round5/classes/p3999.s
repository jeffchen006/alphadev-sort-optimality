# n=5 model=out iset=I1 prefix14_class=3999
mov S1, P1
cmp P1, P0
mov S0, P2
cmovle P1, P0
cmovg S1, P0
cmp P2, P3
cmovg S0, P3
mov P0, S1
cmovg P3, P2
cmp P0, S0
cmovg P0, S0
cmovge S0, S1
cmp P1, P3
cmovl P0, P1
