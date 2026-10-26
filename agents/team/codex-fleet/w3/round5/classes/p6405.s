# n=5 model=out iset=I1 prefix14_class=6405
cmp P1, P3
cmovg S0, P1
cmovg P1, P3
cmovg P3, S0
mov S1, P2
cmp P0, S1
cmovle P2, P0
cmovge S1, P0
cmovl P0, S1
cmp P3, P0
cmovg S1, P3
cmovle P0, P3
cmp P2, P1
mov S1, P0
