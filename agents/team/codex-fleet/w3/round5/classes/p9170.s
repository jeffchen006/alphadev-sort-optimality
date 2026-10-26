# n=5 model=out iset=I1 prefix14_class=9170
cmp P2, P1
mov S0, P1
cmovg P1, P2
cmovle S0, P2
cmp P0, P3
mov P2, P3
cmovl P3, P0
cmovle P0, P2
cmp P3, S0
cmovge S1, P3
cmovg P3, S0
mov P3, P0
cmovge S0, S1
cmp P1, P3
