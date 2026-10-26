# n=5 model=out iset=I1 prefix14_class=4384
mov S0, P1
mov S1, P0
cmp P0, P3
cmovge S1, P3
cmovle P0, P3
cmp P1, P2
mov P3, S1
cmovl P1, P2
cmovl P2, S0
cmp P3, P2
cmovle P3, P2
mov S2, P3
cmovg S1, P2
mov S1, P1
