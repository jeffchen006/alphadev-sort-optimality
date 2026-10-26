# n=5 model=out iset=I1 prefix14_class=9186
cmp P2, P3
mov S0, P3
cmovl P3, P2
mov S1, P0
cmovge S0, P2
cmp P1, S1
cmovl P0, P1
cmovle P1, S1
cmp P3, P0
cmovg S2, P3
cmovg P3, P0
cmovg P0, S2
cmp P1, S0
mov P3, S0
