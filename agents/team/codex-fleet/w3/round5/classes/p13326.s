# n=5 model=out iset=I1 prefix14_class=13326
cmp P3, P2
cmovge S0, P3
cmovg P3, P2
mov S2, P3
cmovg P2, S0
cmp P0, P1
mov S1, P0
cmovl P0, P1
cmovl P1, S1
cmp P1, P3
cmovle P3, P1
cmovge S2, P1
cmp P0, P2
mov P3, P2
